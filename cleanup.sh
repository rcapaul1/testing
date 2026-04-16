#!/bin/bash

# ==========================================
# ROOT-CHECK & AUTO-RESTART
# ==========================================
if [ "$EUID" -ne 0 ]; then
    echo "Fordere Administratorrechte (root) an..."
    exec sudo "$0" "$@"
fi

echo "=========================================="
echo "Start der täglichen Systemreinigung..."
echo "(Läuft mit root-Rechten)"
echo "=========================================="

# 1. Temporäre Verzeichnisse leeren
echo "Lösche temporäre Dateien in /tmp/..."
rm -rf /tmp/* /tmp/.* 2>/dev/null

echo "Lösche temporäre Dateien in /var/tmp/..."
rm -rf /var/tmp/* /var/tmp/.* 2>/dev/null

# 2. Paket-Cache leeren (mit automatischer Distro-Erkennung)
echo "Erkenne Linux-Distribution für Paket-Cleanup..."

if [ -f /etc/os-release ]; then
    # Lade die Variablen aus os-release
    . /etc/os-release
    OS=$ID
    OS_LIKE=$ID_LIKE
else
    # Fallback für extrem alte Systeme
    OS=$(uname -s)
fi

# Fallunterscheidung für die gängigsten Paketmanager
if [[ "$OS" == *"debian"* || "$OS" == *"ubuntu"* || "$OS_LIKE" == *"debian"* || "$OS_LIKE" == *"ubuntu"* ]]; then
    echo "Debian/Ubuntu-basiertes System erkannt. Nutze apt..."
    apt-get clean 2>/dev/null
    apt-get autoremove -y 2>/dev/null

elif [[ "$OS" == *"fedora"* || "$OS" == *"centos"* || "$OS" == *"rhel"* || "$OS_LIKE" == *"fedora"* || "$OS_LIKE" == *"rhel"* ]]; then
    echo "Red Hat/Fedora-basiertes System erkannt. Nutze dnf/yum..."
    if command -v dnf >/dev/null 2>&1; then
        dnf clean all 2>/dev/null
        dnf autoremove -y 2>/dev/null
    else
        yum clean all 2>/dev/null
        yum autoremove -y 2>/dev/null
    fi

elif [[ "$OS" == *"arch"* || "$OS_LIKE" == *"arch"* ]]; then
    echo "Arch-basiertes System erkannt. Nutze pacman..."
    # Leert den Cache (behält nur die aktuell installierten Versionen)
    pacman -Sc --noconfirm 2>/dev/null

elif [[ "$OS" == *"suse"* || "$OS_LIKE" == *"suse"* ]]; then
    echo "SUSE-basiertes System erkannt. Nutze zypper..."
    zypper clean -a 2>/dev/null

else
    echo "Distribution konnte nicht eindeutig zugeordnet werden. Überspringe Paket-Cleanup."
fi

# 3. System-Journale bereinigen (älter als 7 Tage)
if command -v journalctl >/dev/null 2>&1; then
    echo "Bereinige alte System-Journale..."
    journalctl --vacuum-time=7d 2>/dev/null
fi

echo "=========================================="
echo "Reinigung erfolgreich abgeschlossen!"
echo "=========================================="
sleep 3
