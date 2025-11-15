#!/bin/bash
set -euo pipefail

echo "--- Tearing down the Seafile Docker environment ---"

# The --env-file flags are not strictly necessary for `down`, but they are included
# for consistency and to avoid potential issues if the docker-compose.yml file
# were to change in a way that requires them.
docker-compose --env-file config.env --env-file passwords.env down --volumes

echo "✅ Seafile Docker environment has been completely removed."
