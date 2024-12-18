#!/bin/bash

# Verificar si la variable de entorno NGINX_INTERFACE está configurada
if [ -z "$NGINX_INTERFACE" ]; then
    echo "No se pudo detectar la interfaz de red. Verifica la configuración de la variable de entorno NGINX_INTERFACE."
    exit 1
fi

# Ajustar el MTU de la interfaz detectada
echo "Adjusting MTU for $NGINX_INTERFACE to 1500"
ip link set $NGINX_INTERFACE mtu 1500

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

# Reemplazar la interfaz en el archivo de configuración de Suricata
sed -i "s/INTERFACE/$NGINX_INTERFACE/g" /etc/suricata/suricata.yaml

# Iniciar Suricata con la interfaz detectada
echo "Starting Suricata on interface $NGINX_INTERFACE..."
exec suricata -c /etc/suricata/suricata.yaml -i $NGINX_INTERFACE -vv