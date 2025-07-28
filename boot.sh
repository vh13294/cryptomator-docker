#!/bin/sh

./home/cryptomator-cli/bin/cryptomator-cli unlock \
# --loopbackHostName 0.0.0.0 \
--loopbackPort $VAULT_PORT \
--volumeId $VAULT_NAME \
--password:env VAULT_PASS \
--mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
$VAULT_PATH

# tail -f /dev/null