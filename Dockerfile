FROM debian:bookworm-slim

ENV VAULT_NAME demoVault
ENV VAULT_PATH /cryptomatorDir
ENV VAULT_PASS password
ENV CRYPTOMATOR_PORT 8181

EXPOSE 8181

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl unzip \
    && curl -L "https://github.com/cryptomator/cli/releases/download/0.6.2/cryptomator-cli-0.6.2-linux-x64.zip" -o /tmp/cryptomator-cli.zip \
    && unzip /tmp/cryptomator-cli.zip -d /opt \
    && rm /tmp/cryptomator-cli.zip \
    && apt-get purge -y curl unzip \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /opt/cryptomator-cli/bin/cryptomator-cli /usr/local/bin/cryptomator-cli

COPY boot.sh /usr/local/bin/boot.sh
# change permission
RUN chmod +x /usr/local/bin/boot.sh

# run at startup
CMD /usr/local/bin/boot.sh
