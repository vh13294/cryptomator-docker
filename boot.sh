#!/bin/sh

./home/cryptomator-cli/bin/cryptomator-cli unlock \
--password:env VAULT_PASS \
--mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
$VAULT_PATH

# tail -f /dev/null