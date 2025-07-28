#!/bin/sh

./home/cryptomator-cli/bin/cryptomator-cli unlock \
--loopbackPort $VAULT_PORT \
--volumeId $VAULT_NAME \
--password:env VAULT_PASS \
--mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
$VAULT_PATH

# tail -f /dev/null