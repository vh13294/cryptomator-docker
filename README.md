# Synology-Cryptomator

Mount a Cryptomator vault directly on your Synology NAS and access it over WebDAV.

[![Docker Hub](https://img.shields.io/docker/pulls/vh13294/cryptomator-synology)](https://hub.docker.com/r/vh13294/cryptomator-synology)

## Available Tags

| Tag | Vault Format |
|-----|-------------|
| `cryptomator-synology:vault-format-8` | Format 8 (current) |
| `cryptomator-synology:vault-format-7` | Format 7 (legacy) |

## Quick Start (Demo)

A pre-built demo vault is included in the `demo/` folder. Run it locally to try the setup:

```bash
docker run -d \
  -v "$(pwd)/demo:/cryptomatorDir/demo" \
  -p 8181:8181 \
  -e VAULT_NAME=demo \
  -e VAULT_PASS=123456789 \
  -e CRYPTOMATOR_PORT=8181 \
  -e TIMEOUT=0 \
  vh13294/cryptomator-synology:vault-format-8
```

Then access the vault at:

```
http://192.168.x.x:8181/demo
```

> Replace `192.168.x.x` with your machine's LAN IP address.

## Setup in Synology NAS

### Volume

| Folder | Mount Path |
|--------|-----------|
| `cryptomatorDir` | `/cryptomatorDir` |

### Port

| Local | Container |
|-------|-----------|
| `8181` | `8181` |

### Environment Variables

| Variable | Example | Description |
|----------|---------|-------------|
| `VAULT_NAME` | `demoVault` | Name of your vault |
| `VAULT_PATH` | `/cryptomatorDir` | Path where the vault folder lives |
| `VAULT_PASS` | `password` | Vault password |
| `CRYPTOMATOR_PORT` | `8181` | Port to serve WebDAV on |
| `TIMEOUT` | `2h` | Auto-shutdown after this duration (`0` to disable) |

## Connecting via WebDAV

Access the vault from any WebDAV client (no username or password required):

```
http://192.168.20.200:8181/demoVault
```

> Replace `192.168.20.200` with your NAS IP address.

## Mounting in Synology File Station

You can also mount the vault as a remote connection directly inside File Station:

**File Station** → **Tools** → **Remote Connection** → **Connection Setup** → **WebDAV**

Use `localhost` or `127.0.0.1` as the hostname when connecting from within the NAS.
