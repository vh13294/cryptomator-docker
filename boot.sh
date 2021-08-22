#!/bin/bash
java -jar /usr/local/bin/cryptomator-cli.jar \
    --vault $VAULT_NAME=$VAULT_PATH --password $VAULT_NAME=$VAULT_PASS \
    --bind 0.0.0.0 --port $CRYPTOMATOR_PORT
