#!/bin/bash
set -euo pipefail

echo "📦 Installing prerequisites and Docker CE..."

apt update -y || { echo "❌ Apt update failed"; exit 1; }

# --- Remove conflicting packages (fixes your error) ---
apt remove -y docker docker-engine docker.io containerd runc || true

# --- Install prerequisites for adding Docker repo ---
apt install -y ca-certificates curl gnupg lsb-release ufw nginx software-properties-common sudo

# --- Add Docker’s official GPG key & repo ---
install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi
chmod a+r /etc/apt/keyrings/docker.gpg

# Determine Ubuntu codename (e.g., jammy, noble)
UBUNTU_CODENAME=$(lsb_release -cs)
echo "Using Ubuntu codename: $UBUNTU_CODENAME"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" \
  > /etc/apt/sources.list.d/docker.list

apt update -y

# --- Install latest Docker CE + Compose plugin ---
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || {
    echo "❌ Failed to install Docker CE or dependencies"; exit 1;
}

# --- Enable and start Docker ---
systemctl enable docker
systemctl start docker

# --- Allow Nginx through firewall if ufw is enabled ---
if command -v ufw >/dev/null 2>&1; then
    ufw allow 'Nginx Full' || echo "⚠️ UFW rule already exists or failed"
fi

echo "✅ Prerequisites installed successfully."
docker --version
docker compose version

