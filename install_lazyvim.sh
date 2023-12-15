#!/bin/bash

# Function to display a prompt for sudo password
sudo_prompt() {
    sudo -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Install curl and git
echo "Installing curl and git..."
sudo apt-get update
sudo apt-get install -y curl git

# 1. Install Neovim
echo "Installing Neovim..."
sudo_prompt
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# 2. Install LazyVim Dependencies
echo "Installing LazyVim Dependencies..."
sudo apt-get install -y unzip build-essential ripgrep fd-find xsel

# Install Nerd Font
echo "Installing Nerd Font..."
# Replace "0xProto.zip" with the downloaded file name
NERD_FONT_FILE="0xProto.zip"
cd ~/Downloads/
unzip "$NERD_FONT_FILE" -d ~/.fonts
fc-cache -fv

# Install LazyGit
echo "Installing LazyGit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Install C Compiler
echo "Installing C Compiler..."
sudo apt-get install -y build-essential

# Install Ripgrep
echo "Installing Ripgrep..."
sudo apt-get install -y ripgrep

# Install Fd
echo "Installing Fd..."
sudo apt-get install -y fd-find

# Install Copy to Clipboard
echo "Installing Copy to Clipboard..."
sudo apt-get install -y xsel

# 3. Install LazyVim
echo "Installing LazyVim..."
# Backup Neovim Files
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Clone the Starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove .git Folder
rm -rf ~/.config/nvim/.git

# Start Neovim
nvim
