#!/bin/bash
set -euo pipefail

# --- Configuration ---
# Source the configuration and passwords, if they exist.
source ./config.sh
if [ -f ./passwords.sh ]; then
    source ./passwords.sh
fi

# --- Pre-flight Checks ---
# Check if Docker and Docker Compose are installed.
if ! command -v docker >/dev/null; then
    echo "❌ Docker is not installed. Please install it before running this script."
    exit 1
fi
if ! command -v docker-compose >/dev/null; then
    echo "❌ Docker Compose is not installed. Please install it before running this script."
    exit 1
fi

# --- Prompt for Credentials ---
# Prompt for any missing credentials.
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

# --- Setup ---
# Create the Seafile data directories.
mkdir -p "${SEAFILE_DIR}/data" "${SEAFILE_DIR}/mysql"

# Generate the docker-compose.yml file from the template.
echo "📄 Generating docker-compose.yml from template..."
sed -e "s/db_dev/${DB_ROOT_PASSWORD}/g" \
    -e "s/me@example.com/${SEAFILE_ADMIN_EMAIL}/g" \
    -e "s/asecret/${SEAFILE_ADMIN_PASSWORD}/g" \
    -e "s/docs.seafile.com/${SEAFILE_HOSTNAME}/g" \
    -e "s|/opt/seafile-data|${SEAFILE_DIR}/data|g" \
    -e "s|/opt/seafile-mysql/db|${SEAFILE_DIR}/mysql|g" \
    docker-compose.yml.template > docker-compose.yml

# --- Docker Compose ---
# Ensure a clean start by removing any old containers, volumes, and networks.
echo "🛑 Ensuring a clean state by removing old containers, volumes, and networks..."
docker-compose down --volumes

# Start the Seafile server.
echo "🚀 Starting Seafile containers..."
docker-compose up -d

# --- Final Message ---
echo "✅ Seafile setup complete. Access via http://${SEAFILE_HOSTNAME}"

