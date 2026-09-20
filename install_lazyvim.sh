#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly CONFIG_SOURCE="${SCRIPT_DIR}/nvim_config"
readonly LAZYGIT_VERSION="0.52.1"
readonly FONT_VERSION="v3.4.0"
DRY_RUN=0
SKIP_SYSTEM_DEPS=0
NON_INTERACTIVE=0

usage() {
  cat <<'EOF'
Usage: install_lazyvim.sh [options]
  --dry-run             Show actions without changing the system or HOME
  --skip-system-deps   Skip apt, Neovim, LazyGit, and font installation
  --non-interactive    Never prompt for sudo
  -h, --help           Show this help
EOF
}
log() { printf '[lazyvim] %s\n' "$*"; }
die() {
  printf '[lazyvim] error: %s\n' "$*" >&2
  exit 1
}
run() { if ((DRY_RUN)); then
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
else "$@"; fi; }

for arg in "$@"; do
  case "$arg" in
  --dry-run) DRY_RUN=1 ;; --skip-system-deps) SKIP_SYSTEM_DEPS=1 ;;
  --non-interactive) NON_INTERACTIVE=1 ;; -h | --help)
    usage
    exit 0
    ;;
  *) die "unknown option: $arg" ;;
  esac
done
[[ -d "$CONFIG_SOURCE" && -f "$CONFIG_SOURCE/init.lua" ]] || die "configuration directory is missing: $CONFIG_SOURCE"

SUDO=(sudo)
[[ "${EUID}" -eq 0 ]] && SUDO=()
((NON_INTERACTIVE)) && [[ "${EUID}" -ne 0 ]] && SUDO+=(-n)
as_root() { run "${SUDO[@]}" "$@"; }

install_system_deps() {
  command -v apt-get >/dev/null 2>&1 || die "this installer requires apt-get"
  if ((NON_INTERACTIVE)) && [[ "${EUID}" -ne 0 ]]; then "${SUDO[@]}" -n true || die "sudo credentials unavailable"; fi
  as_root apt-get update
  as_root apt-get install -y --no-install-recommends ca-certificates curl git unzip tar gzip build-essential cmake ripgrep fd-find tree-sitter-cli xsel xclip wl-clipboard python3 python3-venv python3-pip golang nodejs npm fontconfig
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    as_root ln -sfn "$(command -v fdfind)" /usr/local/bin/fd
  fi
}

install_neovim() {
  local arch archive url tmp
  case "$(uname -m)" in x86_64) archive=nvim-linux-x86_64.tar.gz ;; aarch64 | arm64) archive=nvim-linux-arm64.tar.gz ;; *) die "unsupported architecture: $(uname -m)" ;; esac
  url="https://github.com/neovim/neovim/releases/latest/download/${archive}"
  tmp="$(mktemp -d)"
  trap 'rm -rf -- "$tmp"' RETURN
  run curl -fL --retry 3 -o "$tmp/$archive" "$url"
  run tar -xzf "$tmp/$archive" -C "$tmp"
  as_root rm -rf "/opt/${archive%.tar.gz}"
  as_root mv "$tmp/${archive%.tar.gz}" "/opt/${archive%.tar.gz}"
  as_root ln -sfn "/opt/${archive%.tar.gz}/bin/nvim" /usr/local/bin/nvim
  trap - RETURN
  rm -rf -- "$tmp"
}

install_lazygit() {
  local arch archive tmp url
  case "$(uname -m)" in x86_64) arch=x86_64 ;; aarch64 | arm64) arch=arm64 ;; *) die "unsupported architecture for LazyGit" ;; esac
  archive="lazygit_${LAZYGIT_VERSION}_Linux_${arch}.tar.gz"
  url="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/${archive}"
  tmp="$(mktemp -d)"
  trap 'rm -rf -- "$tmp"' RETURN
  run curl -fL --retry 3 -o "$tmp/$archive" "$url"
  run tar -xzf "$tmp/$archive" -C "$tmp" lazygit
  as_root install -m 0755 "$tmp/lazygit" /usr/local/bin/lazygit
  trap - RETURN
  rm -rf -- "$tmp"
}

install_font() {
  local tmp="$(mktemp -d)" url="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/0xProto.zip" fonts="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
  trap 'rm -rf -- "$tmp"' RETURN
  run curl -fL --retry 3 -o "$tmp/0xProto.zip" "$url"
  run mkdir -p "$fonts"
  run unzip -q -o "$tmp/0xProto.zip" -d "$fonts"
  run fc-cache -f
  trap - RETURN
  rm -rf -- "$tmp"
}

backup_path() {
  local path="$1" stamp candidate n=0
  [[ -e "$path" ]] || return 0
  stamp="$(date +%Y%m%d-%H%M%S)"
  candidate="${path}.bak.${stamp}"
  while [[ -e "$candidate" ]]; do
    n=$((n + 1))
    candidate="${path}.bak.${stamp}.${n}"
  done
  if ((DRY_RUN)); then
    log "would back up $path to $candidate"
  else
    run mv -- "$path" "$candidate"
    log "backed up $path to $candidate"
  fi
}

install_config() {
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim" data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim" state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nvim" cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
  run mkdir -p "$(dirname "$config_dir")" "$(dirname "$data_dir")" "$(dirname "$state_dir")" "$(dirname "$cache_dir")"
  backup_path "$config_dir"
  backup_path "$data_dir"
  backup_path "$state_dir"
  backup_path "$cache_dir"
  run cp -a "$CONFIG_SOURCE" "$config_dir"
  log "installed configuration at $config_dir"
}

bootstrap() {
  command -v nvim >/dev/null 2>&1 || die "nvim is not available"
  run nvim --headless '+Lazy! sync' '+qa'
  run nvim --headless '+checkhealth' '+qa'
}
main() {
  ((SKIP_SYSTEM_DEPS)) || {
    install_system_deps
    install_neovim
    install_lazygit
    install_font
  }
  install_config
  ((DRY_RUN)) || bootstrap
  log "installation complete; run :LazyHealth inside Neovim for the full report"
}
main "$@"
