#!/bin/bash
echo "$VAULT_PASS" | /usr/local/bin/cryptomator-cli unlock \
    --password:stdin \
    --mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
    --loopbackHostName=0.0.0.0 \
    --loopbackPort=$CRYPTOMATOR_PORT \
    --mountPoint=/tmp/vault-mount \
    "$VAULT_PATH/$VAULT_NAME"
