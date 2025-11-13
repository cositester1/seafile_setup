#!/bin/bash
set -euo pipefail

# Set working directory for Docker Compose
SEAFILE_DIR="/opt/seafile"
COMPOSE_FILE="$SEAFILE_DIR/docker-compose.yml"

echo "🛑 Removing old containers, volumes, and networks if they exist..."

# Stop and remove any container related to Seafile
EXISTING_CONTAINERS=$(docker ps -a --format '{{.Names}}' | grep 'seafile' || true)
if [ -n "$EXISTING_CONTAINERS" ]; then
    echo "🧹 Removing old Seafile containers..."
    docker rm -f $EXISTING_CONTAINERS || true
fi

# Remove old networks
EXISTING_NETWORKS=$(docker network ls --format '{{.Name}}' | grep 'seafile' || true)
if [ -n "$EXISTING_NETWORKS" ]; then
    echo "🧹 Removing old Seafile networks..."
    for NET in $EXISTING_NETWORKS; do
        echo "   Removing network: $NET"
        docker network rm "$NET" || true
    done
fi

# Remove orphaned volumes (optional)
docker volume prune -f >/dev/null 2>&1 || true

# Ensure the compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ docker-compose.yml not found in $SEAFILE_DIR"
    echo "   Please verify your installation."
    exit 1
fi

echo "🚀 Starting Seafile containers..."
cd "$SEAFILE_DIR"

# Bring everything up fresh
docker compose down || true
docker compose up -d

echo "✅ Seafile containers are up and running:"
docker ps --filter "name=seafile"

