#!/bin/bash
set -euo pipefail

SERVICE_FILE="/etc/systemd/system/seafile-docker.service"
WORKDIR="/opt/seafile"

echo "🔧 Creating systemd service..."

# Create the systemd service unit
sudo tee "$SERVICE_FILE" >/dev/null <<EOF
[Unit]
Description=Seafile Docker Compose
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$WORKDIR
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Systemd service file written to $SERVICE_FILE"

# Reload systemd, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable seafile-docker.service

echo "🚀 Starting Seafile Docker service..."
if ! sudo systemctl start seafile-docker.service; then
    echo "❌ Failed to start service. Showing logs:"
    sudo journalctl -xeu seafile-docker.service | tail -n 20
    exit 1
fi

echo "✅ Seafile Docker service started successfully."
sudo systemctl status seafile-docker.service --no-pager

