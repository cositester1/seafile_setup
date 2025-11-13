# Seafile Docker Setup Scripts

This repository contains a set of shell scripts to automate the setup of a Seafile server using Docker, Nginx, and a self-signed SSL certificate for local HTTPS.

## Prerequisites

- A Debian-based Linux distribution (e.g., Ubuntu, Debian).
- `sudo` privileges.

## Quick Start

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd seafile-docker-setup
    ```

2.  **Configure the setup:**
    Open the `config.sh` file and customize the variables, especially `SEAFILE_HOSTNAME`, to match your environment.

3.  **Set up credentials (Optional, for non-interactive setup):**
    For a non-interactive setup (e.g., in automated scripts), you can provide your credentials in a `passwords.sh` file.

    - Copy the example file:
      ```bash
      cp passwords.sh.example passwords.sh
      ```
    - Edit `passwords.sh` and replace the placeholder values with your actual credentials. This file is ignored by git, so your secrets are safe.

4.  **Run the setup script:**
    ```bash
    chmod +x *.sh
    sudo ./setup.sh
    ```
    If you did not create a `passwords.sh` file, the script will prompt you to enter the necessary passwords during the setup process.

## How It Works

The `setup.sh` script orchestrates the entire process by calling the other scripts in the correct order:

1.  `setup_prerequisites.sh`: Installs Docker, Docker Compose, Nginx, and other required packages.
2.  `setup_certificate.sh`: Generates a self-signed SSL certificate for the configured hostname using `mkcert`.
3.  `setup_nginx.sh`: Configures Nginx as a reverse proxy for the Seafile services.
4.  `setup_docker.sh`:
    - Prompts for credentials if `passwords.sh` is not found.
    - Generates the `docker-compose.yml` file from the template.
    - Starts the Seafile Docker containers.
5.  `setup_systemd.sh`: Creates and enables a systemd service to manage the Seafile Docker containers.

After the setup is complete, you can access your Seafile instance at `https://<your-hostname>`.
