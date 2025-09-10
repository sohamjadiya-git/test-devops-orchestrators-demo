#!/bin/bash

REPO_URL="https://github.com/veltrix-capital/test-devops-orchestrators.git"
REPO_DIR="test-devops-orchestrators"

# install_git()

# install_node()

detect_and_install_dependencies() {
    if command -v node &>/dev/null && command -v npm &>/dev/null && command -v git &>/dev/null; then
        echo "[INFO] Node.js already installed: $(node -v)"
        echo "[INFO] npm version: $(npm -v)"
        echo "[INFO] git is already installed: $(git -v)"
        return
    fi

    echo "[INFO] Node.js, npm or git not found. Attempting installation..."

    case "$OS" in
        Linux*)
            if [ -f /etc/debian_version ]; then
                echo "[INFO] Installing Node.js via apt..."
                curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash 
                sudo apt install -y nodejs
                echo "[INFO] Installing Git via apt..."
                sudo apt install git-all
            elif [ -f /etc/redhat-release ]; then
                echo "[INFO] Installing Node.js via yum..."
                curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
                sudo yum install -y nodejs
                echo "[INFO] Installing Git via yum..."
                sudo yum install -y git
            else
                echo "[WARN] Unsupported Linux distro. Please install Node.js, Git manually."
                exit 1
            fi
            ;;
        Darwin*)
            if command -v brew &>/dev/null; then
                echo "[INFO] Installing Node.js via Homebrew..."
                brew install node
            else
                echo "[ERROR] Homebrew not found. Please install Node.js manually."
                exit 1
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "[INFO] Detected Windows (Git Bash or WSL). Please install Node.js manually from https://nodejs.org/"
            exit 1
            ;;
        *)
            echo "[ERROR] Unknown OS: $OS"
            exit 1
            ;;
    esac
}

detect_and_install_dependencies
# if ! command -v git &> /dev/null; then
#     echo "[ERROR] Git is not installed. Please install Git first." >&2
# fi 
# # Step 1: Clone or update the repository
# if [ -d "$REPO_DIR/.git" ]; then
#     echo "[+] Repository exists. Pulling latest changes..."
#     cd "$REPO_DIR" && git pull
# else
#     echo "[+] Cloning repository..."
#     git clone "$REPO_URL" "$REPO_DIR"
#     cd "$REPO_DIR" || { echo "Failed to enter directory"; exit 1; }
# fi

# # Step 2: Make scripts executable
# echo "[+] Granting execution permissions..."
# chmod +x setup.sh start.sh

# # Step 3: Run setup.sh
# echo "[+] Running setup.sh..."
# ./setup.sh

# echo "Setup is completed"
