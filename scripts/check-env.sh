#!/usr/bin/env bash
# Pre-course environment check for macOS and Linux.
# Usage: bash scripts/check-env.sh
# Read-only: changes nothing on the machine.

fail=0; warn=0
if [ -t 1 ]; then G=$'\e[32m'; Y=$'\e[33m'; R=$'\e[31m'; C=$'\e[36m'; N=$'\e[0m'; else G=; Y=; R=; C=; N=; fi

pass() { printf '%s[PASS]%s %-26s %s\n' "$G" "$N" "$1" "$2"; }
warn() { printf '%s[WARN]%s %-26s %s\n' "$Y" "$N" "$1" "$2"; warn=$((warn+1)); }
fail() { printf '%s[FAIL]%s %-26s %s\n' "$R" "$N" "$1" "$2"; fail=$((fail+1)); }
has()  { command -v "$1" >/dev/null 2>&1; }

os=$(uname -s)
printf '\n%sAI Vibe Coding with Claude - environment check (%s)%s\n' "$C" "$os" "$N"
printf -- '------------------------------------------------------------\n'

# --- Hardware -----------------------------------------------------------------
if [ "$os" = "Darwin" ]; then
  ram=$(( $(sysctl -n hw.memsize) / 1073741824 ))
else
  ram=$(( $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1048576 ))
fi
if [ "$ram" -ge 15 ]; then pass "RAM" "${ram} GB"
elif [ "$ram" -ge 8 ]; then warn "RAM" "${ram} GB (16 GB recommended to run Docker and a VM together)"
else fail "RAM" "${ram} GB (at least 8 GB required)"; fi

free=$(df -Pk "$HOME" | awk 'NR==2 {print int($4/1048576)}')
if [ "$free" -ge 60 ]; then pass "Free disk" "${free} GB"
elif [ "$free" -ge 30 ]; then warn "Free disk" "${free} GB (60 GB recommended)"
else fail "Free disk" "${free} GB (need at least 30 GB)"; fi

arch=$(uname -m)
if [ "$os" = "Darwin" ] && [ "$arch" = "arm64" ]; then
  warn "CPU" "Apple Silicon - use UTM or Multipass for the Ubuntu VM (see README)"
elif [ "$os" = "Linux" ]; then
  if grep -Eq 'vmx|svm' /proc/cpuinfo; then pass "Virtualization" "CPU supports VT-x/AMD-V"
  else fail "Virtualization" "not available - enable VT-x/AMD-V in BIOS"; fi
fi

# --- Tools --------------------------------------------------------------------
if has git; then pass "Git" "$(git --version)"; else fail "Git" "not found"; fi

if has node; then
  v=$(node -v); major=${v#v}; major=${major%%.*}
  if [ "$major" -ge 20 ] && [ $((major % 2)) -eq 0 ]; then pass "Node.js" "$v"
  else warn "Node.js" "$v (install the current LTS from https://nodejs.org)"; fi
else fail "Node.js" "not found - install LTS from https://nodejs.org"; fi

if has npm; then pass "npm" "$(npm -v)"; else fail "npm" "not found"; fi
if has code; then pass "VS Code" "code command found"; else warn "VS Code" "'code' not on PATH"; fi
if has claude; then pass "Claude Code CLI" "$(claude --version 2>/dev/null)"
else warn "Claude Code CLI" "not found (optional if you use the VS Code extension)"; fi

# --- Docker -------------------------------------------------------------------
if has docker; then
  if docker info >/dev/null 2>&1; then pass "Docker engine" "$(docker version --format '{{.Server.Version}}')"
  else fail "Docker engine" "installed but not running - start Docker Desktop / dockerd"; fi
  if docker compose version >/dev/null 2>&1; then pass "Docker Compose" "$(docker compose version --short)"
  else fail "Docker Compose" "compose plugin not found"; fi
else fail "Docker" "not found - https://docs.docker.com/get-docker/"; fi

# --- VM software --------------------------------------------------------------
if has VBoxManage; then
  pass "VirtualBox" "$(VBoxManage --version)"
  if VBoxManage list vms | grep -q vibe-server; then pass "Course VM" "'vibe-server' exists"
  else warn "Course VM" "'vibe-server' not created yet (done on Day 3)"; fi
elif has utmctl || [ -d "/Applications/UTM.app" ]; then pass "UTM" "installed"
elif has multipass; then pass "Multipass" "$(multipass version | head -1)"
else fail "VM software" "install VirtualBox (or UTM/Multipass on Apple Silicon)"; fi

if ls "$HOME"/Downloads/ubuntu-*-live-server-*.iso >/dev/null 2>&1; then
  pass "Ubuntu Server ISO" "$(basename "$(ls "$HOME"/Downloads/ubuntu-*-live-server-*.iso | head -1)")"
else warn "Ubuntu Server ISO" "not found in ~/Downloads - https://ubuntu.com/download/server"; fi

# --- Ports used in the labs ---------------------------------------------------
for port in 5173 8080 5432; do
  if has lsof && lsof -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
    warn "Port $port" "in use (labs can use another port via .env)"
  else pass "Port $port" "free"; fi
done

# --- Network ------------------------------------------------------------------
for h in github.com registry-1.docker.io claude.ai api.trycloudflare.com; do
  if curl -s -o /dev/null --max-time 8 "https://$h"; then pass "Reach $h" "ok"
  else fail "Reach $h" "blocked - check proxy/firewall"; fi
done

printf -- '------------------------------------------------------------\n'
printf '%d FAIL, %d WARN\n' "$fail" "$warn"
if [ "$fail" -gt 0 ]; then printf '%sFix FAIL items before Day 2. See day-1-intro/README.md%s\n' "$R" "$N"; exit 1; fi
printf '%sReady for Day 2.%s\n' "$G" "$N"
