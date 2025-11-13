#!/bin/bash
set -euo pipefail

source ./config.sh

# --- Load credentials ---
if [ -f "passwords.sh" ]; then
    echo "🔑 Loading credentials from passwords.sh"
    source ./passwords.sh
else
    echo "⚠️ passwords.sh not found. Prompting for credentials..."
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
sed -e "s,{{SEAFILE_HOSTNAME}},$SEAFILE_HOSTNAME,g" \
    -e "s,{{DB_ROOT_PASSWORD}},$DB_ROOT_PASSWORD,g" \
    -e "s,{{SEAFILE_ADMIN_EMAIL}},$SEAFILE_ADMIN_EMAIL,g" \
    -e "s,{{SEAFILE_ADMIN_PASSWORD}},$SEAFILE_ADMIN_PASSWORD,g" \
    -e "s,{{SEAFILE_SERVER_IMAGE}},$SEAFILE_SERVER_IMAGE,g" \
    -e "s,{{SEAHUB_IMAGE}},$SEAHUB_IMAGE,g" \
    -e "s,{{SEAHUB_MEDIA_IMAGE}},$SEAHUB_MEDIA_IMAGE,g" \
    -e "s,{{MARIADB_IMAGE}},$MARIADB_IMAGE,g" \
    -e "s,{{MEMCACHED_IMAGE}},$MEMCACHED_IMAGE,g" \
    -e "s,{{SEAFILE_CADDY_IMAGE}},$SEAFILE_CADDY_IMAGE,g" \
    "$TEMPLATE_FILE" > "$COMPOSE_FILE"

echo "🛑 Stopping and removing old containers, volumes, and networks if they exist..."
cd "$SEAFILE_DIR"
docker compose down --volumes || true

# Ensure the compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "❌ docker-compose.yml not found in $SEAFILE_DIR"
    echo "   Please verify your installation."
    exit 1
fi

echo "🚀 Starting Seafile containers..."
cd "$SEAFILE_DIR"

# Bring everything up fresh
docker compose up -d

echo "✅ Seafile containers are up and running:"
docker ps --filter "name=seafile"
