# Seafile Docker Setup Script

This repository contains a shell script to automate the setup of a Seafile server using Docker, closely following the official Seafile Docker deployment guide.

## Prerequisites

- Docker and Docker Compose installed on your system.
- `sudo` privileges.

## Quick Start

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd seafile-docker-setup
    ```

2.  **Configure the setup:**
    Open the `config.sh` file and customize the `SEAFILE_HOSTNAME` and `SEAFILE_DIR` variables to match your environment.

3.  **Set up credentials (Optional, for non-interactive setup):**
    For a non-interactive setup, you can provide your credentials in a `passwords.sh` file.

    - Copy the example file:
      ```bash
      cp passwords.sh.example passwords.sh
      ```
    - Edit `passwords.sh` and replace the placeholder values with your actual credentials. This file is ignored by git, so your secrets are safe.

4.  **Run the setup script:**
    ```bash
    chmod +x setup.sh
    sudo ./setup.sh
    ```
    If you did not create a `passwords.sh` file, the script will prompt you for the necessary credentials.

## How It Works

The `setup.sh` script automates the following steps:
1.  **Sources Configuration:** Loads settings from `config.sh` and `passwords.sh`.
2.  **Checks Prerequisites:** Verifies that Docker and Docker Compose are installed.
3.  **Prompts for Credentials:** Asks for any missing passwords if `passwords.sh` is not used.
4.  **Creates Directories:** Ensures the necessary data directories for Seafile and its database exist.
5.  **Generates Compose File:** Creates a `docker-compose.yml` file from the official template, substituting your configured values.
6.  **Ensures a Clean Start:** Runs `docker-compose down --volumes` to remove any previous Seafile containers, networks, and volumes.
7.  **Starts Seafile:** Executes `docker-compose up -d` to launch the Seafile server.

After the setup is complete, you can access your Seafile instance at `http://<your-hostname>`.
