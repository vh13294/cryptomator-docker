#!/bin/bash
if [ -z "$_TIMEOUT_WRAPPED" ]; then
    export _TIMEOUT_WRAPPED=1
    exec timeout --foreground "$TIMEOUT" "$0" "$@"
fi

INTERNAL_PORT=$((CRYPTOMATOR_PORT + 10000))

socat TCP-LISTEN:$CRYPTOMATOR_PORT,bind=0.0.0.0,fork,reuseaddr TCP:localhost:$INTERNAL_PORT &
SOCAT_PID=$!

cleanup() {
    kill "$CRYPTO_PID" 2>/dev/null
    kill "$SOCAT_PID" 2>/dev/null
    exit 0
}
trap cleanup INT TERM

echo "$VAULT_PASS" | /usr/local/bin/cryptomator-cli unlock \
    --password:stdin \
    --mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
    --loopbackPort=$INTERNAL_PORT \
    "$VAULT_PATH/$VAULT_NAME" &
CRYPTO_PID=$!

wait $CRYPTO_PID
cleanup
