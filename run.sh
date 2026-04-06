#!/bin/bash

# Exporter les variables d'environnement pour node
export DHOST="${DHOST:-cdn.worldsolution.site}"
export DPORT="${DPORT:-22}"
export PACKSKIP="${PACKSKIP:-0}"

# Démarrer les services locaux
tmux new-session -d -s a0 'badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 250 --max-connections-for-client 3'
tmux new-session -d -s b0 'dropbear -REF -p 40000 -W 65535'

# Démarrer le proxy
echo "=== Proxy SSH WebSocket ==="
echo "Redirection vers ${DHOST}:${DPORT}"
node proxy3.js
exit
