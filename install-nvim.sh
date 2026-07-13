#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/fleece30/bash.git"
CONFIG_DIR="$HOME/.config/nvim"
INSTALL_DIR="/opt/nvim"
GIT_BRANCH="lab-nvim-config"

echo "==> Installing Neovim..."
ARCH=$(uname -m)
if [ "$ARCH" == "aarch64" ]; then
	NVIM_ARCH="arm64"
else
	NVIM_ARCH=""
fi

curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
tar xzf "nvim-linux-${NVIM_ARCH}.tar.gz"
rm -rf "$INSTALL_DIR"
mv "nvim-linux-${NVIM_ARCH}" "$INSTALL_DIR"
rm "nvim-linux-${NVIM_ARCH}.tar.gz"
ln -sf "$INSTALL_DIR/bin/nvim" /usr/local/bin/nvim

echo "==> Installing dependencies"
apt update -qq
apt install -y git curl unzip built-essential ripgrep fd-find

echo "==> Cloning nvim config"
if [ -d "$CONFIG_DIR" ]; then
	echo "Config exists at $CONFIG_DIR - pulling latest"
	git -C "$CONFIG_DIR" pull
else
	git clone "$REPO_URL" "$CONFIG_DIR"
	git checkout $GIT_BRANCH
fi

echo "==> Syncing plugins..."
nvim --headless "+Lazy! sync" +qa

echo "==> nvim setup finished. Run 'nvim' to validate."
