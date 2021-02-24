# host-docker-internal

Container to add to Docker Compose to get `host.docker.internal` on Linux.

# Intro

This is the source repo for [docker.io/benizi/host.docker.internal][dockerhub].
Its only purpose is to provide a Docker container (for use in Docker Compose) that forwards all its network traffic to a single IP (the host running Docker Compose).
It uses the same `iptables` + capabilities approach as [qoomon/docker-host][original], but its use case is intentionally much more limited in scope.

[dockerhub]: https://hub.docker.com/repository/docker/benizi/host.docker.internal
[original]: https://github.com/qoomon/docker-host

# Usage

Add to Docker Compose `docker-compose.yml` (or `docker-compose.override.yml`):

```yaml
version: "3.8"
services:
  host:
    image: benizi/host.docker.internal
    cap_add: [NET_ADMIN, NET_RAW]
    networks: { default: { aliases: [host.docker.internal] } }
    restart: on-failure
```

- The capabilities in `cap_add` are required for `iptables`
- The `networks` setting is optional, but that's the main reason this exists
- The `restart` setting is probably overly cautious (shouldn't be any reason it would fail, but it doesn't hurt)

## Configuration

Configuration can be done through environment variables, e.g., in the `docker-compose.yml` service:

```yaml
# ...
services:
  host:
    environment:
      ## Set the destination ...
      # ... by IP
      IP: '10.1.2.1'
      # ... or hostname (resolved in the container)
      HOST: 'service.network.internal'
      # Forward these port ranges: (default: `0:65535`)
      PORTS: 80:100,8800:8900

      ## Print `iptables` stats this frequently (default: `1h`)
      STATS: 1m

      ## Debugging options
      # Enable debugging (any non-empty value)
      DEBUG: 'yup'
      # ... or just for printing environment variables beforehand:
      DEBUG_ENV: 'yup'
      # ... or just for the `/entrypoint` script (mainly for my own use):
      DEBUG_SCRIPT: 'yup'
```

# Features

- Determine IP for forwarding:
  - [x] Specify forwarding IP via `$IP` (directly)
  - [x] Specify forwarding IP via `$HOST` (resolved in the container)
  - [x] Use default gateway IP otherwise

# License

Copyright © 2020–2021 Benjamin R. Haskell

Distributed under the MIT License (included in file: [LICENSE](LICENSE)).
