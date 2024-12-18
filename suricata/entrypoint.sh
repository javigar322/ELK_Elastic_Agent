#!/bin/bash

# Detectar la interfaz de red activa (excluyendo `lo`)
INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)

if [ -z "$INTERFACE" ]; then
    echo "No active network interface found!"
    exit 1
fi

# Ajustar el MTU de la interfaz detectada
echo "Deberia de funcionar este. Adjusting MTU for $INTERFACE to 1500"
ip link set $INTERFACE mtu 1500

# Actualizar reglas de Suricata si está habilitado
if [ "$SURICATA_UPDATE_ENABLED" = "true" ]; then
    echo "Updating Suricata rules..."
    suricata-update
    suricata-update enable-source et/open
    suricata-update
fi

# Combinar reglas personalizadas si existen
if [ -f /etc/suricata/rules/custom.rules ]; then
    echo "Appending custom rules..."
    cat /etc/suricata/rules/custom.rules >> /var/lib/suricata/rules/suricata.rules
fi

# Iniciar Suricata con la interfaz detectada
echo "Starting Suricata on interface $INTERFACE..."
exec suricata -c /etc/suricata/suricata.yaml -i $INTERFACE -vv
