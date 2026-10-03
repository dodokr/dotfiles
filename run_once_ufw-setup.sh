#!/bin/bash
# ufw setup: base services + hotspot hosting (NetworkManager shared mode).
# Usage: sudo bash ~/ufw-setup.sh [wifi-interface]
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo bash $0" >&2; exit 1; }

# Wifi interface used for the hotspot. Override: sudo bash ufw-setup.sh wlp2s0
WIFI_IF="${1:-$(iw dev 2>/dev/null | awk '$1=="Interface"{print $2; exit}')}"
WIFI_IF="${WIFI_IF:-wlan0}"
HOTSPOT_NET="10.42.0.0/24"   # NetworkManager default shared subnet
HOTSPOT_GW="10.42.0.1"       # this machine's address when hosting
echo "Using wifi interface: $WIFI_IF"

# --- Services (always) ---
ufw allow 22/tcp          comment 'ssh'
ufw allow 53317/tcp       comment 'localsend'
ufw allow 53317/udp       comment 'localsend'

# --- Hotspot hosting (only matter while this machine runs the hotspot) ---
ufw allow in on "$WIFI_IF" from "$HOTSPOT_NET"                     comment 'hotspot clients in'
ufw allow out on "$WIFI_IF" to "$HOTSPOT_NET"                      comment 'hotspot clients out'
ufw route allow in on "$WIFI_IF"                                   comment 'hotspot forward in'
ufw route allow out on "$WIFI_IF"                                  comment 'hotspot forward out'
ufw allow in on "$WIFI_IF" to "$HOTSPOT_GW" port 53 proto udp      comment 'hotspot dns'
ufw allow in on "$WIFI_IF" to "$HOTSPOT_GW" port 53 proto tcp      comment 'hotspot dns'
ufw allow in on "$WIFI_IF" to any port 67 proto udp                comment 'hotspot dhcp'

ufw --force enable
ufw status numbered

# --- NetworkManager hotspot connection (created once, not started) ---
# Start it later with: nmcli connection up Hotspot
HOTSPOT_NAME="Hotspot"
if nmcli -t -f NAME connection show | grep -qx "$HOTSPOT_NAME"; then
    echo "NM connection '$HOTSPOT_NAME' already exists, skipping"
else
    # Password comes from $HOTSPOT_PSK (sudo HOTSPOT_PSK=... bash ...) or a prompt
    PSK="${HOTSPOT_PSK:-}"
    if [[ -z "$PSK" ]]; then
        read -rsp "Hotspot password (min 8 chars): " PSK; echo
    fi
    [[ ${#PSK} -ge 8 ]] || { echo "Password must be at least 8 characters" >&2; exit 1; }

    nmcli connection add type wifi ifname "$WIFI_IF" con-name "$HOTSPOT_NAME" \
        autoconnect no ssid "$HOTSPOT_NAME" \
        802-11-wireless.mode ap 802-11-wireless.band bg \
        ipv4.method shared ipv6.method ignore \
        wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$PSK"
    echo "Created '$HOTSPOT_NAME'. Start it with: nmcli connection up $HOTSPOT_NAME"
fi

