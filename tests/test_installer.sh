#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
temp_root="$(mktemp -d)"
trap 'rm -rf -- "$temp_root"' EXIT

fake_bin="$temp_root/bin"
fake_home="$temp_root/home"
mkdir -p "$fake_bin" "$fake_home" "$fake_home/config/nvim"

cat > "$fake_bin/nvim" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod 0755 "$fake_bin/nvim"
printf 'previous configuration\n' > "$fake_home/config/nvim/previous.txt"

export HOME="$fake_home"
export PATH="$fake_bin:$PATH"
export XDG_CONFIG_HOME="$fake_home/config"
export XDG_DATA_HOME="$fake_home/data"
export XDG_STATE_HOME="$fake_home/state"
export XDG_CACHE_HOME="$fake_home/cache"

cd /tmp
bash "$repo_root/install_lazyvim.sh" --skip-system-deps --non-interactive

test -f "$XDG_CONFIG_HOME/nvim/init.lua"
test -f "$XDG_CONFIG_HOME/nvim/lua/config/lazy.lua"
test -f "$XDG_CONFIG_HOME/nvim/.neoconf.json"
test -f "$XDG_CONFIG_HOME/nvim.bak."*/previous.txt

bash "$repo_root/install_lazyvim.sh" --dry-run --skip-system-deps --non-interactive
test -f "$XDG_CONFIG_HOME/nvim/init.lua"

printf 'isolated installer test passed\n'
