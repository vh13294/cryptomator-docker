#!/bin/bash
cryptomator-cli unlock \
    --password:env=VAULT_PASS \
    --mounter=org.cryptomator.frontend.webdav.mount.FallbackMounter \
    --loopbackHostName=0.0.0.0 \
    --loopbackPort=$CRYPTOMATOR_PORT \
    $VAULT_PATH
