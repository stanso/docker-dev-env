# README

- `UID=$(id -u) GID=$(id -g) docker compose up`
- `UID=$(id -u) GID=$(id -g) docker compose start`
- `docker compose down` for cleanup
- `docker compose exec tailscale tailscale up` for Tailscale login 

- `docker buildx build --push --platform linux/arm64,linux/amd64 --tag stanso/ubuntu-dev-env:latest .` for building and pushing
