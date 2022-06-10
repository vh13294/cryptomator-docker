# Synology-Cryptomator

Mount Cryptomator directly in your Synology NAS.
The files will be accessible via WebDav protocol.

- cryptomator-synology:vault-format-8
- cryptomator-synology:vault-format-7

Docker Hub:
https://hub.docker.com/r/vh13294/cryptomator-synology

In Synology NAS

- Volume

  - Folder: cryptomatorDir -> MountPath: /cryptomatorDir

- Port Setting

  - Local: 8181 -> Container: 8181

- Environment
  - TIMEOUT: 2h (server will shutdown after 2h of running)
  - TIMEOUT: 0 (disable timeout and server will run indefinitely)
  - VAULT_NAME: demoVault
  - VAULT_PATH: /cryptomatorDir
  - VAULT_PASS: password
  - CRYPTOMATOR_PORT: 8181

In your WebDav client (guest account, no username/password)

- Mounted URL:
  - 192.168.20.200:8181/demoVault

(Assuming 192.168.20.200 is your NAS IP)

You can also mount WebDav as remote connect in synology file station.

[File Station] -> [Tools] -> [Remote Connection] -> [Connection Setup] -> [WebDav]

Hostname will be 'localhost' or '127.0.0.1'
