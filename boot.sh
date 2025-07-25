#!/bin/bash
./home/cryptomator-cli/cryptomator-cli unlock \
--password:$VAULT_PASS \
--mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
$VAULT_PATH
