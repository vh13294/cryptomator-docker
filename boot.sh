#!/bin/bash
if [ -z "$_TIMEOUT_WRAPPED" ]; then
    export _TIMEOUT_WRAPPED=1
    exec timeout --foreground "$TIMEOUT" "$0" "$@"
fi

INTERNAL_PORT=$((CRYPTOMATOR_PORT + 10000))
TMPLOG=$(mktemp)

cleanup() {
    kill "$CRYPTO_PID" "$TAIL_PID" 2>/dev/null
    nginx -s quit 2>/dev/null
    rm -f "$TMPLOG"
    exit 0
}
trap cleanup INT TERM

# Start cryptomator-cli, log to temp file
echo "$VAULT_PASS" | /usr/local/bin/cryptomator-cli unlock \
    --password:stdin \
    --mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
    --loopbackPort=$INTERNAL_PORT \
    "$VAULT_PATH" > "$TMPLOG" 2>&1 &
CRYPTO_PID=$!

# Stream logs to stdout so docker logs works
tail -f "$TMPLOG" &
TAIL_PID=$!

# Wait until vault is unlocked or cryptomator exits
until grep -q "mounted vault successfully to" "$TMPLOG" 2>/dev/null; do
    if ! kill -0 "$CRYPTO_PID" 2>/dev/null; then
        echo "Cryptomator failed to start:" >&2
        cat "$TMPLOG" >&2
        exit 1
    fi
    sleep 0.5
done

# Parse the random UUID path cryptomator generates on each start
VAULT_UUID=$(grep "mounted vault successfully to" "$TMPLOG" | \
    grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1)

echo "Vault mounted at internal path: /$VAULT_UUID/"
echo "WebDAV accessible at: http://0.0.0.0:$CRYPTOMATOR_PORT/"

# Write nginx config: proxy fixed root / to the UUID path, rewriting hrefs in responses
cat > /tmp/cryptomator-nginx.conf << EOF
events {}
http {
    # Rewrite Destination header for COPY/MOVE: strip scheme+host, prepend UUID path.
    # Handles both http and https (e.g. when this container sits behind a TLS proxy).
    map \$http_destination \$webdav_dest {
        ~*^https?://[^/]+(/.+)$ "http://127.0.0.1:$INTERNAL_PORT/$VAULT_UUID\$1";
        default "";
    }

    server {
        listen $CRYPTOMATOR_PORT;
        location / {
            proxy_pass http://127.0.0.1:$INTERNAL_PORT/$VAULT_UUID/;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header Host \$http_host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
            proxy_set_header Destination \$webdav_dest;
            proxy_request_buffering off;
            proxy_max_temp_file_size 0;
            client_max_body_size 0;
            sub_filter "/$VAULT_UUID/" "/";
            sub_filter_once off;
            sub_filter_types text/xml application/xml;
        }
    }
}
EOF

nginx -c /tmp/cryptomator-nginx.conf -g "daemon off;" &

wait $CRYPTO_PID
cleanup
