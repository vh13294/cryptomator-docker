FROM debian:12-slim

ENV TIMEOUT=2h
ENV VAULT_NAME=demoVault
ENV VAULT_PATH=/cryptomatorDir
ENV VAULT_PASS=password
ENV CRYPTOMATOR_PORT=8181

RUN apt-get update && apt-get install -y --no-install-recommends curl unzip \
    && curl -L https://github.com/cryptomator/cli/releases/download/0.6.2/cryptomator-cli-0.6.2-linux-x64.zip -o /tmp/cli.zip \
    && unzip /tmp/cli.zip -d /tmp/cli \
    && mv /tmp/cli/cryptomator-cli /usr/local/bin/cryptomator-cli \
    && chmod +x /usr/local/bin/cryptomator-cli \
    && rm -rf /tmp/cli /tmp/cli.zip \
    && apt-get remove -y curl unzip && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /tmp/vault-mount

EXPOSE 8181

COPY boot.sh /usr/local/bin/boot.sh
RUN chmod +x /usr/local/bin/boot.sh

CMD timeout $TIMEOUT /usr/local/bin/boot.sh
