#!/bin/bash

# Funktion zum Stoppen aller Container
function cleanup {
    echo ""
    echo "--- Aufräumarbeiten ---"
    echo "Stoppe alle Docker Container..."
    # 'docker ps -a -q' listet alle Container IDs auf
    docker stop $(docker ps -a -q)
    echo "Alles gestoppt. Feierabend."
}

# Trap fängt das Signal EXIT (Skriptende) ab und führt 'cleanup' aus.
# Das ist die klassische Art, Ressourcen sauber freizugeben.
trap cleanup EXIT

# 1. Alle Container starten
echo "--- Starte Umgebung ---"
# Wir leiten stderr nach /dev/null um, falls keine Container da sind, um Lärm zu vermeiden
if [ -n "$(docker ps -a -q)" ]; then
    docker start $(docker ps -a -q) > /dev/null
    echo "Alle Container wurden gestartet."
else
    echo "Keine Container zum Starten gefunden."
    exit 0
fi

# 2. Ziel-Container auswählen
# Wenn du dem Script kein Argument mitgegeben hast, fragt es dich.
TARGET_CONTAINER="$1"

if [ -z "$TARGET_CONTAINER" ]; then
    echo "-----------------------"
    echo "Verfügbare Container:"
    docker ps --format "table {{.Names}}\t{{.Status}}"
    echo "-----------------------"
    read -p "In welchen Container möchtest du (Name eingeben)? " TARGET_CONTAINER
fi

# 3. In den Container wechseln
# Checken, ob der Container überhaupt läuft
if [ "$(docker inspect -f '{{.State.Running}}' $TARGET_CONTAINER 2>/dev/null)" = "true" ]; then
    echo "Gehe in Container: $TARGET_CONTAINER ..."
    echo "Tipp: Mit 'exit' verlässt du den Container und stoppst alles."
    
    # Exec mit /bin/bash wie gewünscht
    docker exec -it "$TARGET_CONTAINER" /bin/bash
else
    echo "Fehler: Container '$TARGET_CONTAINER' konnte nicht gefunden werden oder läuft nicht."
fi

# Sobald docker exec endet (durch 'exit'), greift der 'trap' und führt 'cleanup' aus.
