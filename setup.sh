#!/bin/bash
set -euo pipefail

# --- Pre-flight checks ---
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

function check_prerequisites() {
    echo "--- Checking prerequisites ---"
    local missing_commands=()
    for cmd in docker docker-compose openssl; do
        if ! command_exists "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done

    if [ ${#missing_commands[@]} -gt 0 ]; then
        echo "❌ Error: The following commands are not installed: ${missing_commands[*]}"
        echo "   Please install them before running this script."
        exit 1
    fi
    echo "✅ Prerequisites are satisfied."
}

# --- Configuration ---
function load_config() {
    echo "--- Loading configuration ---"
    if [ ! -f config.env ]; then
        echo "❌ Error: config.env not found. Please create it from the example."
        exit 1
    fi
    source config.env

    if [ -f passwords.env ]; then
        source passwords.env
    else
        echo "⚠️ Warning: passwords.env not found. You will be prompted for passwords."
    fi
    echo "✅ Configuration loaded."
}

# --- Self-signed SSL certificate ---
function generate_ssl_certificate() {
    echo "--- Generating self-signed SSL certificate ---"
    local cert_dir="${SEAFILE_VOLUME}/ssl"
    mkdir -p "$cert_dir"

    if [ -f "${cert_dir}/seafile.key" ] && [ -f "${cert_dir}/seafile.crt" ]; then
        echo "✅ SSL certificate already exists. Skipping generation."
        return
    fi

    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
        -keyout "${cert_dir}/seafile.key" -out "${cert_dir}/seafile.crt" \
        -subj "/CN=${SEAFILE_SERVER_HOSTNAME}"
    echo "✅ SSL certificate generated."
}

# --- Docker setup ---
function start_docker_containers() {
    echo "--- Starting Docker containers ---"
    docker-compose --env-file config.env --env-file passwords.env up -d
    echo "✅ Seafile containers are up and running."
}

# --- Main ---
function main() {
    check_prerequisites
    load_config
    generate_ssl_certificate
    start_docker_containers

    echo "🎉 Seafile setup is complete!"
    echo "   Access your Seafile instance at https://${SEAFILE_SERVER_HOSTNAME}"
}

main
