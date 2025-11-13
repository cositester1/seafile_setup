#!/bin/bash
set -euo pipefail

source ./config.sh

# --- Prompt for credentials if not set ---
if [ -z "${DB_ROOT_PASSWORD:-}" ]; then
    read -rsp "Enter the root password for the database: " DB_ROOT_PASSWORD
    echo
fi
if [ -z "${SEAFILE_ADMIN_EMAIL:-}" ]; then
    read -rp "Enter the email address for the Seafile admin: " SEAFILE_ADMIN_EMAIL
fi
if [ -z "${SEAFILE_ADMIN_PASSWORD:-}" ]; then
    read -rsp "Enter the password for the Seafile admin: " SEAFILE_ADMIN_PASSWORD
    echo
fi

# --- Generate docker-compose.yml from template ---
echo "📄 Generating docker-compose.yml from template..."
TEMPLATE_FILE="docker-compose.yml.template"
COMPOSE_FILE="$SEAFILE_DIR/docker-compose.yml"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ $TEMPLATE_FILE not found."
    exit 1
fi

mkdir -p "$SEAFILE_DIR"
sed -e "s/{{SEAFILE_HOSTNAME}}/$SEAFILE_HOSTNAME/g" \
    -e "s/{{DB_ROOT_PASSWORD}}/$DB_ROOT_PASSWORD/g" \
    -e "s/{{SEAFILE_ADMIN_EMAIL}}/$SEAFILE_ADMIN_EMAIL/g" \
    -e "s/{{SEAFILE_ADMIN_PASSWORD}}/$SEAFILE_ADMIN_PASSWORD/g" \
    "$TEMPLATE_FILE" > "$COMPOSE_FILE"

echo "🛑 Ensuring a clean state by removing old containers, volumes, and networks..."

# Ensure the compose file exists before we proceed
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ docker-compose.yml not found in $SEAFILE_DIR"
    echo "   Please verify your installation."
    exit 1
fi

# Change to the Seafile directory to manage the Docker environment
cd "$SEAFILE_DIR"

# Use docker compose to tear down the entire environment, including volumes.
# This ensures a completely fresh start.
docker compose down --volumes

echo "🚀 Starting Seafile containers..."
docker compose up -d

echo "✅ Seafile containers are up and running:"
docker ps --filter "name=seafile"
