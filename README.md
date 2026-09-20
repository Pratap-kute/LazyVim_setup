# LazyVim Ubuntu Setup

Automated LazyVim and Neovim setup for Ubuntu and Pop!_OS.

[![Installer validation](https://github.com/Pratap-kute/lazyvim-ubuntu-setup/actions/workflows/installer.yml/badge.svg)](https://github.com/Pratap-kute/lazyvim-ubuntu-setup/actions/workflows/installer.yml)

This project installs the tools LazyVim needs and copies a ready-to-use
Neovim configuration into place. It is intended for developers who want a
working editor setup without rebuilding the same environment by hand.

Licensed under the [MIT License](LICENSE).

The repository contains the installer, the complete configuration, and an
experimental Docker setup:

- `install_lazyvim.sh` installs the system dependencies and configuration.
- `nvim_config/` contains the LazyVim setup and personal plugin settings.
- `lazyvim_in_docker/` contains a Docker-based experiment for isolated use.

## Install

Clone the repository, enter it, and run the installer:

```bash
git clone https://github.com/Pratap-kute/lazyvim-ubuntu-setup.git
cd lazyvim-ubuntu-setup
./install_lazyvim.sh
```

The script is designed for Ubuntu and Pop!_OS systems using `apt`. It supports
x86-64 and ARM64 Linux machines.

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
./install_lazyvim.sh --skip-bootstrap
./install_lazyvim.sh --non-interactive
./install_lazyvim.sh --help
```

`--dry-run` prints the actions without changing the system. Use
`--skip-system-deps` when the required tools are already installed. The
`--skip-bootstrap` option copies the configuration without synchronizing
plugins, which is useful on offline machines or in CI. The
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

These checks run automatically on Ubuntu 22.04 and 24.04 through the
[installer validation workflow](https://github.com/Pratap-kute/lazyvim-ubuntu-setup/actions/workflows/installer.yml).

For the official installation requirements, see the
[LazyVim documentation](https://www.lazyvim.org/installation).

## Troubleshooting

If installation stops while installing system packages, run the script again
after fixing the reported `apt` or `sudo` issue. Existing Neovim directories
are backed up before the new configuration is copied, so the previous setup is
available under the timestamped `.bak.*` path.

If plugins do not install, check that GitHub is reachable and run `nvim` again.
Inside Neovim, use `:Lazy` to inspect plugin errors and `:LazyHealth` for the
dependency report. Codeium requires a separate `:Codeium Auth` login.
