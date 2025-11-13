#!/bin/bash

# --- General ---
# Hostname for Seafile, e.g., "seafile.example.com" or a local name like "iasis.lan"
export SEAFILE_HOSTNAME="iasis.lan"

# --- Directories ---
# Installation directory for Seafile
export SEAFILE_DIR="/opt/seafile"
# Directory for storing SSL certificates
export CERT_DIR="/etc/ssl/seafile"

# --- Nginx ---
# Nginx config file path
export NGINX_CONF="/etc/nginx/sites-available/seafile.conf"
# Nginx enabled site symlink
export NGINX_ENABLED="/etc/nginx/sites-enabled/seafile.conf"

# --- Systemd ---
# Systemd service file path
export SERVICE_FILE="/etc/systemd/system/seafile-docker.service"

echo "✅ Configuration loaded for $SEAFILE_HOSTNAME"
