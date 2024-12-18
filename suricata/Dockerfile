FROM jasonish/suricata:latest


# Variables de entorno
ENV SURICATA_UPDATE_ENABLED=true


# Copiar el script de entrada y las configuraciones
COPY entrypoint.sh /entrypoint.sh
COPY config/suricata.yaml /etc/suricata/suricata.yaml
COPY rules/custom.rules /etc/suricata/rules/custom.rules


# Otorgar permisos de ejecución al script
RUN chmod +x /entrypoint.sh


# EntryPoint personalizado
ENTRYPOINT ["/entrypoint.sh"]