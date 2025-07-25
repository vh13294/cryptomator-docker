FROM alpine:latest

ENV TIMEOUT 2h
ENV VAULT_NAME demoVault
ENV VAULT_PATH /cryptomatorDir
ENV VAULT_PASS password
ENV CRYPTOMATOR_PORT 8181

EXPOSE 8181

# Install unzip
RUN apk update && \
    apk add --no-cache unzip && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

# Declare TARGETARCH as an ARG in this stage to make it available
ARG TARGETARCH

# Define the base URL for your binary downloads
ENV BASE_DOWNLOAD_URL="https://github.com/cryptomator/cli/releases/download/0.6.2/cryptomator-cli-0.6.2-linux-"

# Construct the download URL based on TARGETARCH
# We use a case statement for more complex mapping if needed,
# or direct concatenation if the architecture name matches the URL suffix.
RUN case "${TARGETARCH}" in \
    amd64) \
        DOWNLOAD_SUFFIX="x64"; \
        ;; \
    arm64) \
        DOWNLOAD_SUFFIX="aarch64"; \
        ;; \
    *) \
        echo "Unsupported architecture: ${TARGETARCH}"; \
        exit 1; \
        ;; \
    esac && \
    curl -L "${BASE_DOWNLOAD_URL}-${DOWNLOAD_SUFFIX}.zip" --output /home/cryptomator-cli.zip

RUN unzip /home/cryptomator-cli.zip

COPY boot.sh /usr/local/bin/boot.sh
# change permission
RUN chmod +x /usr/local/bin/boot.sh

# run at startup
CMD timeout $TIMEOUT /usr/local/bin/boot.sh