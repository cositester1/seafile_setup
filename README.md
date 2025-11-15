# Seafile Docker Setup

This repository contains a simplified set of scripts to automate the setup of a Seafile server using Docker.

## Prerequisites

- A Debian-based Linux distribution (e.g., Ubuntu, Debian).
- `sudo` privileges.
- The following commands installed: `docker`, `docker-compose`, and `openssl`.

## Quick Start

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd seafile-docker-setup
    ```

2.  **Configure the setup:**
    - Create a `config.env` file from the `config.env.example` file and customize the variables, especially `SEAFILE_HOSTNAME`, to match your environment.
    - Create a `passwords.env` file from the `passwords.env.example` file and provide your desired credentials. This file is ignored by git, so your secrets are safe.

3.  **Run the setup script:**
    ```bash
    chmod +x *.sh
    sudo ./setup.sh
    ```
    The script will check for prerequisites, generate a self-signed SSL certificate, and start the Seafile Docker containers.

4.  **Access your Seafile instance:**
    After the setup is complete, you can access your Seafile instance at `https://<your-hostname>`.

## Teardown

To completely remove the Seafile Docker environment, including all data, run the `teardown.sh` script:

```bash
sudo ./teardown.sh
```

This will stop and remove the Docker containers, volumes, and networks associated with this setup.
