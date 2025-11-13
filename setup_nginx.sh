#!/bin/bash
set -euo pipefail

source ./config.sh

echo "🌐 Configuring Nginx..."
if [ -f "$NGINX_CONF" ]; then
    echo "   -> Nginx configuration already exists. Skipping."
else
    cat <<EOF > "$NGINX_CONF"
server {
    listen 443 ssl;
    server_name $SEAFILE_HOSTNAME;

    ssl_certificate $CERT_DIR/seafile.crt;
    ssl_certificate_key $CERT_DIR/seafile.key;

    location /seafhttp {
        rewrite ^/seafhttp(.*)\$ \$1 break;
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Forwarded-Proto https;
        client_max_body_size 0;
        proxy_connect_timeout 3600s;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
        send_timeout 3600s;
    }

    location / {
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header Host \$http_host;
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Forwarded-Proto https;
    }

    location /seafdav {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header X-Forwarded-Proto https;
        client_max_body_size 0;
        proxy_connect_timeout 3600s;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
        send_timeout 3600s;
    }
}

server {
    listen 80;
    server_name $SEAFILE_HOSTNAME;
    return 301 https://\$host\$request_uri;
}
EOF
fi

# The following lines are commented out to prevent Nginx from starting and
# conflicting with the Caddy container on port 80.
# ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
# nginx -t || { echo "❌ Nginx configuration test failed"; exit 1; }
# systemctl reload nginx || echo "⚠️ Nginx reload failed, maybe first install"

echo "✅ Nginx configured, but not enabled, to avoid port conflicts with Docker."

