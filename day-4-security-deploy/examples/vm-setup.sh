#!/usr/bin/env bash
# Prepare an Ubuntu Server VM for the course: Docker Engine + Compose plugin + basic firewall.
# Follows https://docs.docker.com/engine/install/ubuntu/
set -euo pipefail

sudo apt-get update
sudo apt-get install -y ca-certificates curl ufw

# Docker's official apt repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Run docker without sudo (takes effect after re-login)
sudo usermod -aG docker "$USER"

# Firewall: only SSH inbound. Cloudflare Tunnel (Day 4) is outbound-only, so no web ports are needed.
# Note: ports published by Docker (`ports:` in compose) bypass ufw, so avoid publishing ports you do not need.
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "Done. Log out and back in, then run: docker run --rm hello-world"
