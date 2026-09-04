#!/bin/bash

set -e

echo "=== Docker Installation ==="

# Make sure we're running on Debian
if [ ! -f /etc/os-release ]; then
    echo "Unable to determine Linux distribution."
    exit 1
fi

. /etc/os-release

if [ "$ID" != "debian" ]; then
    echo "This script is intended for Debian."
    echo "Detected: $PRETTY_NAME"
    exit 1
fi

echo "Detected: $PRETTY_NAME"
echo "Codename: $VERSION_CODENAME"

# --------------------------------------------------
# Remove old Docker packages
# --------------------------------------------------

echo
echo "=== Removing old Docker packages ==="

sudo apt remove -y \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc \
    || true

# --------------------------------------------------
# Install prerequisites
# --------------------------------------------------

echo
echo "=== Installing prerequisites ==="

sudo apt update

sudo apt install -y \
    ca-certificates \
    curl

# --------------------------------------------------
# Add Docker GPG key
# --------------------------------------------------

echo
echo "=== Adding Docker GPG key ==="

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL \
    https://download.docker.com/linux/debian/gpg \
    -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# --------------------------------------------------
# Add Docker APT repository
# --------------------------------------------------

echo
echo "=== Adding Docker APT repository ==="

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian \
    ${VERSION_CODENAME} stable" |
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --------------------------------------------------
# Install Docker
# --------------------------------------------------

echo
echo "=== Installing Docker ==="

sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# --------------------------------------------------
# Configure Docker
# --------------------------------------------------

echo
echo "=== Configuring Docker ==="

sudo mkdir -p /etc/docker

sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
    "exec-opts": [
        "native.cgroupdriver=systemd"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

# --------------------------------------------------
# Enable and start Docker
# --------------------------------------------------

echo
echo "=== Starting Docker ==="

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker

# --------------------------------------------------
# Add current user to docker group
# --------------------------------------------------

echo
echo "=== Configuring docker group ==="

sudo usermod -aG docker "$USER"

# --------------------------------------------------
# Verify installation
# --------------------------------------------------

echo
echo "=== Docker installation complete ==="

sudo docker --version

echo
echo "Docker service:"
sudo systemctl --no-pager --full status docker

echo
echo "=============================================="
echo "Docker has been installed successfully."
echo
echo "Your user ($USER) was added to the docker group."
echo "Log out and log back in before running Docker"
echo "without sudo."
echo
echo "Then verify with:"
echo "  docker version"
echo "  docker run hello-world"
echo "=============================================="
