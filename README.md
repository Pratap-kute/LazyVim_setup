# LazyVim setup

This repository contains my LazyVim configuration and the installer I use to
set it up on Ubuntu or Pop!_OS. The configuration lives in `nvim_config/` and
includes the LazyVim extras and personal plugin settings used by this setup.

## Install

Clone the repository, enter it, and run the installer:

```bash
git clone <repository-url>
cd LazyVim_setup
./install_lazyvim.sh
```

The installer will:

- install the current stable Neovim release and the tools LazyVim needs;
- install Tree-sitter CLI, a C/C++ toolchain, Go, Node.js, Python, ripgrep,
  fd, LazyGit, clipboard support, and a Nerd Font;
- back up existing Neovim configuration, data, state, and cache directories;
- copy this repository's `nvim_config/` into `~/.config/nvim`; and
- bootstrap the plugins and run a headless health check.

It does not clone the default LazyVim starter over the custom configuration.

LazyVim currently requires Neovim 0.11.2 or newer, Git 2.19 or newer, a C
compiler, and the Tree-sitter CLI. The installer uses the architecture-specific
Neovim release for x86-64 and ARM64 systems.

## Installer options

```bash
./install_lazyvim.sh --dry-run
./install_lazyvim.sh --skip-system-deps
./install_lazyvim.sh --non-interactive
./install_lazyvim.sh --help
```

`--dry-run` prints the actions without changing the system. Use
`--skip-system-deps` when the required tools are already installed. The
non-interactive mode is useful for automation, but it still requires working
sudo credentials unless the script is run as root.

Existing Neovim directories are moved to timestamped paths such as
`~/.config/nvim.bak.20260920-105514`, so the previous setup can be restored if
needed. The installer also respects `XDG_CONFIG_HOME`, `XDG_DATA_HOME`,
`XDG_STATE_HOME`, and `XDG_CACHE_HOME`.

## After installation

Start Neovim with:

```bash
nvim
```

Then run `:LazyHealth` to check the complete setup. Codeium authentication,
terminal font selection, and attaching to an external Delve server are manual
steps because they depend on the local environment.

## Configuration layout

The files in `nvim_config/lua/config/` contain the general Neovim settings.
Files in `nvim_config/lua/plugins/` add or override plugins. The
`nvim_config/lazyvim.json` file records the enabled LazyVim extras, while
`nvim_config/lazy-lock.json` keeps the tested plugin revisions pinned.

The configuration also includes the current LazyVim starter bootstrap and the
official `.neoconf.json` defaults.

## Testing

The installer can be tested without touching the host Neovim installation by
using a temporary HOME and XDG directories. The repository tests this way for
configuration copying, timestamped backups, and headless startup. A real
plugin bootstrap still needs network access to GitHub.

For the official installation requirements, see the
[LazyVim documentation](https://www.lazyvim.org/installation).
