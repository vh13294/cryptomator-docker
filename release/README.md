# Publishing to Docker Hub

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Logged in to Docker Hub:

```bash
docker login
```

## Publish

Run the publish script from the **project root**:

```bash
bash release/docker.publish
```

This will:
1. Build the image for `linux/amd64`
2. Tag it as `vault-format-8`, `0.6.2`, and `latest`
3. Push all tags to [vh13294/cryptomator-synology](https://hub.docker.com/r/vh13294/cryptomator-synology)

## Updating the version

When upgrading the Cryptomator CLI:

1. Update the download URL and `VERSION` in [docker.publish](docker.publish)
2. Update the download URL in the root [Dockerfile](../Dockerfile)
3. Rebuild and republish
