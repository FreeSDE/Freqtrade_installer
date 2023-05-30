# Freqtrade Installer

This script automates the installation process of Freqtrade, a cryptocurrency trading bot, on Debian-based Linux distributions. 

## Script Features

### 1. OS Compatibility Check

The script verifies if your system is running a Debian-based Linux distribution. It will still run on unsupported systems after displaying a warning, but this is not advised.

### 2. Previous Installation Check

If an installation attempt is detected from a previous run, the script will prompt you with the choice to continue from where you left off or restart the installation process.

### 3. Installation Choices

You are given the choice to install Freqtrade regularly or within a Docker container. 

- **Docker Installation:** If Docker is not installed, the script will install Docker and Docker Compose. Then, it downloads the Freqtrade Docker image, sets up the necessary directories, and completes the Freqtrade setup within a Docker container. 

- **Regular Installation:** This includes updating repositories, installing necessary packages, cloning the Freqtrade repository, verifying directories, and executing the Freqtrade setup script. 

### 4. Bot Startup

After installation, the script will prompt you with the option to start the bot immediately. 

## Installation Instructions

Simply run the script, and it will guide you through the process. The script will prompt you for necessary inputs and decisions along the way. 

## Note

Although the script does its best to handle potential issues, it's always recommended to understand what the script does before running it. Please review the script and ensure you're comfortable with the actions it performs on your system. If the script fails at any point, the provided messages should guide you towards resolving the issue.