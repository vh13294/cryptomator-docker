# Synology-Cryptomator

Mount a Cryptomator vault directly on your Synology NAS and access it over WebDAV.

[![Docker Hub](https://img.shields.io/docker/pulls/vh13294/cryptomator-synology)](https://hub.docker.com/r/vh13294/cryptomator-synology)

## Available Tags

| Tag | Vault Format |
|-----|-------------|
| `cryptomator-synology:vault-format-8` | Format 8 (current) |
| `cryptomator-synology:vault-format-7` | Format 7 (legacy) |

## Testing a Local Build

To test changes before pushing, build and run the image locally:

```bash
docker build -t cryptomator-synology:local . && \
docker run --rm \
  -v "$(pwd)/demo:/cryptomatorDir" \
  -p 8181:8181 \
  -e VAULT_PASS=123456789 \
  -e CRYPTOMATOR_PORT=8181 \
  -e TIMEOUT=0 \
  cryptomator-synology:local
```

Then access the vault at:

```
http://192.168.x.x:8181/
```

> Replace `192.168.x.x` with your machine's LAN IP address.

## Setup in Synology NAS

### Volume

Mount your vault folder directly to `/cryptomatorDir`:

| Host Path | Mount Path |
|-----------|-----------|
| `/volume1/.../myVault` | `/cryptomatorDir` |

### Network

Set the network mode to **host**. This allows File Station to connect via `localhost` and removes the need for port mapping.

> In bridge mode, Synology cannot reach its own container IP from File Station due to hairpin NAT limitations.

### Environment Variables

| Variable | Example | Description |
|----------|---------|-------------|
| `VAULT_PATH` | `/cryptomatorDir` | Path where the vault is mounted (default, no change needed) |
| `VAULT_PASS` | `password` | Vault password |
| `CRYPTOMATOR_PORT` | `8181` | Port to serve WebDAV on |
| `TIMEOUT` | `2h` | Auto-shutdown after this duration (`0` to disable) |

## Connecting via WebDAV

Access the vault from any WebDAV client (no username or password required):

```
http://192.168.20.200:8181/
```

> Replace `192.168.20.200` with your NAS IP address.

## Mounting with RaiDrive (Windows)

1. Open RaiDrive → **Add Drive** → **NAS** → **WebDAV**
2. Set the **Address** field to: `192.168.20.200:8181` (your NAS IP and port)
3. Set the **Path** field to: `/` (root — the vault is served at root, not a sub-path)
4. Leave **Username** and **Password** empty
5. Make sure **SSL** is **off** (HTTP, not HTTPS)

> If RaiDrive has a single URL field instead of separate address/path fields, enter the full URL: `http://192.168.20.200:8181/`

## Mounting in Synology File Station

You can also mount the vault as a remote connection directly inside File Station:

**File Station** → **Tools** → **Remote Connection** → **Connection Setup** → **WebDAV**

With host network mode, use `localhost` or `127.0.0.1` as the hostname and your configured port (e.g., `8181`).
