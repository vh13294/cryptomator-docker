FROM debian:latest

# Installing dependencies
RUN apt-get update && apt-get install -y default-jre

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TIMEOUT 2h
ENV VAULT_NAME demoVault
ENV VAULT_PATH /cryptomatorDir
ENV VAULT_PASS password
ENV CRYPTOMATOR_PORT 8181

EXPOSE 8181

COPY cryptomator-cli-0.4.0.jar /usr/local/bin/cryptomator-cli.jar

COPY boot.sh /usr/local/bin/boot.sh
# change permission
RUN chmod +x /usr/local/bin/boot.sh

# run at startup
CMD timeout $TIMEOUT /usr/local/bin/boot.sh
