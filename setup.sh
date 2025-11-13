#!/bin/bash
set -euo pipefail

echo "=== Starting Seafile setup ==="

source ./config.sh

./setup_prerequisites.sh
./setup_certificate.sh
./setup_nginx.sh
./setup_docker.sh
./setup_systemd.sh

echo "✅ Seafile setup complete. Access via https://${SEAFILE_HOSTNAME}"

