# LazyVim Setup Documentation for Ubuntu 22.04 or Pop!_OS 22.04

## Table of Contents
1. [Install Neovim](#1-install-neovim)
    - [Download Neovim App Image](#download-neovim-app-image)
    - [Add Permission](#add-permission)
    - [Check Neovim Binary](#check-neovim-binary)
    - [Move Neovim App Image](#move-neovim-app-image)

2. [Install LazyVim Dependencies](#2-install-lazyvim-dependencies)
    - [Git](#git)
    - [Nerd Font](#nerd-font)
    - [LazyGit](#lazygit)
    - [C Compiler for nvim-treesitter](#c-compiler-for-nvim-treesitter)
    - [Ripgrep for Telescope.nvim](#ripgrep-for-telescopenvim)
    - [Fd for Telescope.nvim](#fd-for-telescopenvim)
    - [Copy to Clipboard for Neovim](#copy-to-clipboard-for-neovim)

3. [Install LazyVim](#3-install-lazyvim)
    - [Backup Neovim Files](#backup-neovim-files)
    - [Clone the Starter](#clone-the-starter)
    - [Remove .git Folder](#remove-git-folder)
    - [Start Neovim](#start-neovim)

## 1. Install Neovim

Reference: [The Correct Way to Install Neovim](https://medium.com/thelinux/the-correct-way-to-install-the-neovim-42f3076f9b88)

### Download Neovim App Image

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
```

### Add Permission

```bash
chmod u+x nvim.appimage
```

### Check Neovim Binary

```bash
./nvim.appimage
```

### Move Neovim App Image

```bash
sudo mv nvim.appimage /usr/local/bin/nvim
```

## 2. Install LazyVim Dependencies

### Git

```bash
sudo apt install git
```

### Nerd Font

Reference: [Install Nerd Fonts on Ubuntu](https://linuxspin.com/install-nerd-fonts-on-ubuntu/)

Download your preferred Nerd Font from [Nerd Fonts download page](https://www.nerdfonts.com/font-downloads). Replace "0xProto.zip" with the downloaded file name.

```bash
cd Downloads/
unzip 0xProto.zip -d ~/.fonts
fc-cache -fv
```
If `~/.fonts` does not exist, create it using `mkdir ~/.fonts`.

### LazyGit

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

### C Compiler for nvim-treesitter

```bash
sudo apt install build-essential
```

### Ripgrep for Telescope.nvim

Reference: [Ripgrep GitHub](https://github.com/BurntSushi/ripgrep)

```bash
sudo apt-get install ripgrep
```

### Fd for Telescope.nvim

Reference: [Fd GitHub](https://github.com/sharkdp/fd)

```bash
sudo apt install fd-find
```

### Copy to Clipboard for Neovim

```bash
sudo apt install xsel
```

## 3. Install LazyVim

### Backup Neovim Files

```bash
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

### Clone the Starter

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

### Remove .git Folder

```bash
rm -rf ~/.config/nvim/.git
```

### Start Neovim

```bash
nvim
```

For more details, refer to the [LazyVim installation documentation](https://www.lazyvim.org/installation).