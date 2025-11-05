#!/usr/bin/env bash
# pve-on-debian12.sh
# Proxmox VE 8 auf Debian 12 Bookworm installieren
# Optionen:
#   --auto-reboot    rebootet am Ende automatisch
#   --skip-upgrade   ueberspringt "apt full-upgrade" vor der Installation

set -euo pipefail

AUTO_REBOOT=0
SKIP_UPGRADE=0
for arg in "$@"; do
  case "$arg" in
    --auto-reboot) AUTO_REBOOT=1 ;;
    --skip-upgrade) SKIP_UPGRADE=1 ;;
    *) echo "Unbekannte Option: $arg" >&2; exit 2 ;;
  esac
done

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Bitte als root ausfuehren (sudo -i oder su -)." >&2
    exit 1
  fi
}

check_env() {
  . /etc/os-release
  if [[ "${ID:-}" != "debian" || "${VERSION_CODENAME:-}" != "bookworm" ]]; then
    echo "Dieses Script ist fuer Debian 12 (bookworm). Gefunden: ${PRETTY_NAME:-unbekannt}" >&2
    exit 1
  fi
  if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
    echo "Proxmox VE wird hier fuer amd64 erwartet." >&2
    exit 1
  fi
}

prep_apt() {
  apt-get update
  apt-get install -y --no-install-recommends curl gpg ca-certificates lsb-release apt-transport-https
  install -d -m 0755 /etc/apt/keyrings
}

add_pve_repo() {
  # Offiziellen Proxmox GPG-Key (Bookworm) in Keyring ablegen
  curl -fsSL "https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg" \
    | gpg --dearmor -o /etc/apt/keyrings/proxmox-release-bookworm.gpg

  # No-Subscription Repo einrichten (HTTP gem. Doku)
  cat >/etc/apt/sources.list.d/pve-install-repo.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/proxmox-release-bookworm.gpg] http://download.proxmox.com/debian/pve bookworm pve-no-subscription
EOF
}

upgrade_system() {
  if [[ $SKIP_UPGRADE -eq 0 ]]; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade
  fi
}

install_kernel() {
  # Proxmox Kernel installieren (empfohlen)
  DEBIAN_FRONTEND=noninteractive apt-get install -y proxmox-default-kernel
}

install_pve_stack() {
  # Postfix non-interaktiv auf "Internet Site" setzen mit aktuellem Hostnamen
  local hn
  hn="$(hostname -f 2>/dev/null || hostname)"
  echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
  echo "postfix postfix/mailname string $hn" | debconf-set-selections

  DEBIAN_FRONTEND=noninteractive apt-get install -y proxmox-ve postfix open-iscsi chrony
}

tune_repos() {
  # Enterprise-Repo deaktivieren, falls vorhanden
  local f="/etc/apt/sources.list.d/pve-enterprise.list"
  if [[ -f "$f" ]]; then
    sed -i 's|^[[:space:]]*deb[[:space:]]\+https\?://enterprise.proxmox.com|# &|' "$f" || true
  fi
  apt-get update
}

final_info() {
  echo
  echo "Proxmox VE Installation abgeschlossen."
  echo "Web-UI nach dem Reboot: https://$(hostname -f 2>/dev/null || hostname):8006"
  echo "Login: root (Linux root)  |  Realm: Linux PAM standardmaessig"
  echo
  if [[ $AUTO_REBOOT -eq 1 ]]; then
    echo "System wird jetzt neu gestartet..."
    sleep 3
    reboot
  else
    echo "Bitte System neu starten, damit der Proxmox Kernel aktiv wird:  reboot"
  fi
}

main() {
  require_root
  check_env
  prep_apt
  add_pve_repo
  upgrade_system
  install_kernel
  install_pve_stack
  tune_repos
  final_info
}

main "$@"
