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

# --- Docker Image Versions ---
export SEAFILE_SERVER_IMAGE="ggogel/seafile-server:11.0.13"
export SEAHUB_IMAGE="ggogel/seahub:11.0.13"
export SEAHUB_MEDIA_IMAGE="ggogel/seahub-media:11.0.13"
export MARIADB_IMAGE="mariadb:10.11.10"
export MEMCACHED_IMAGE="memcached:1.6.34"
export SEAFILE_CADDY_IMAGE="ggogel/seafile-caddy:2.8.4"

echo "✅ Configuration loaded for $SEAFILE_HOSTNAME"
