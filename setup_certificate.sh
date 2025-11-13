#!/bin/bash
set -euo pipefail

LOCAL_HOSTNAME="iasis.lan"
CERT_DIR="/etc/ssl/seafile"

echo "🔐 Setting up local HTTPS certificate for $LOCAL_HOSTNAME..."
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/seafile.crt" ]; then
    echo "   -> No certificate found. Generating..."
    curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 -o /usr/local/bin/mkcert
    chmod 755 /usr/local/bin/mkcert
    mkcert -install || { echo "❌ mkcert install failed"; exit 1; }
    mkcert -cert-file "$CERT_DIR/seafile.crt" -key-file "$CERT_DIR/seafile.key" "$LOCAL_HOSTNAME" || { echo "❌ Certificate generation failed"; exit 1; }
    chmod 644 "$CERT_DIR/seafile.crt"
    chmod 600 "$CERT_DIR/seafile.key"
else
    echo "   -> Certificate already exists. Skipping."
fi
echo "✅ Certificate setup complete."

