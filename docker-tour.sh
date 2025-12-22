#!/bin/bash

# --- Funktion zum Aufräumen ---
function cleanup {
    echo ""
    echo "--- Tour beendet ---"
    echo "Stoppe alle Docker Container..."
    # Fehler unterdrücken, falls keine Container da sind
    docker stop $(docker ps -a -q) 2>/dev/null
    echo "Alles sauber heruntergefahren. Bis zum nächsten Mal."
}

# Trap fängt das Signal EXIT ab (egal ob durch Script-Ende oder CTRL+C)
trap cleanup EXIT

# --- 1. Alles starten ---
echo "--- Starte alle Container ---"
if [ -n "$(docker ps -a -q)" ]; then
    docker start $(docker ps -a -q) > /dev/null
    echo "Container sind gestartet/bereit."
else
    echo "Keine Container gefunden."
    exit 0
fi

# --- 2. Die Liste holen ---
# Wir holen uns die Namen aller laufenden Container
# Formatierung sorgt für saubere Namen ohne Anführungszeichen
CONTAINER_LIST=$(docker ps --format "{{.Names}}")

# --- 3. Die Schleife (The Loop) ---
for CONTAINER in $CONTAINER_LIST; do
    echo "------------------------------------------------"
    echo "Betrete Container: $CONTAINER"
    echo "Drücke 'exit' oder STRG+D, um zum nächsten Container zu springen."
    echo "------------------------------------------------"

    # Versuch, mit bash reinzugehen.
    # Falls der Container kein bash hat (z.B. Alpine), geben wir eine Warnung aus
    # und versuchen es optional mit sh (falls du das Fallback möchtest).
    
    docker exec -it "$CONTAINER" /bin/bash

    # Check auf Exit-Code des exec-Befehls
    if [ $? -ne 0 ]; then
        echo "Warnung: '/bin/bash' konnte in '$CONTAINER' nicht ausgeführt werden."
        echo "Vielleicht basiert er auf Alpine? Versuche '/bin/sh'..."
        sleep 1
        docker exec -it "$CONTAINER" /bin/sh
    fi
    
    echo "Verlasse $CONTAINER..."
    sleep 1 # Kurze Pause für die UX, damit es nicht zu hektisch wirkt
done

# Wenn die Schleife durch ist, greift automatisch das 'trap cleanup'
