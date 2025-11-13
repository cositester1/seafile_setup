#!/bin/bash
set -euo pipefail

source ./config.sh

echo "🔐 Setting up local HTTPS certificate for $SEAFILE_HOSTNAME..."
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/seafile.crt" ]; then
    echo "   -> No certificate found. Generating..."
    LATEST_MKCERT_URL=$(curl -sL "https://api.github.com/repos/FiloSottile/mkcert/releases/latest" | grep "browser_download_url.*linux-amd64" | cut -d '"' -f 4)
    if [ -z "$LATEST_MKCERT_URL" ]; then
        echo "❌ Could not determine the latest mkcert version. Using fallback."
        LATEST_MKCERT_URL="https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64"
    fi
    curl -L "$LATEST_MKCERT_URL" -o /usr/local/bin/mkcert
    chmod 755 /usr/local/bin/mkcert
    mkcert -install || { echo "❌ mkcert install failed"; exit 1; }
    mkcert -cert-file "$CERT_DIR/seafile.crt" -key-file "$CERT_DIR/seafile.key" "$SEAFILE_HOSTNAME" || { echo "❌ Certificate generation failed"; exit 1; }
    chmod 644 "$CERT_DIR/seafile.crt"
    chmod 600 "$CERT_DIR/seafile.key"
else
    echo "   -> Certificate already exists. Skipping."
fi
echo "✅ Certificate setup complete."

