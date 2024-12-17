#!/bin/bash


# Ajustar el MTU de la interfaz eth0
echo "Adjusting MTU for eth0 to 1500"
ip link set eth0 mtu 1500


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


# Iniciar Suricata
echo "Starting Suricata..."
exec suricata -c /etc/suricata/suricata.yaml -i eth0 -vv