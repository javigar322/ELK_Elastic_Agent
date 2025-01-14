#!/bin/bash


# Configuración
URL="http://localhost:4280/vulnerabilities/brute/"
NUMBER_OF_REQUESTS=15  # Número de solicitudes
INTERVAL=0.5  # Intervalo entre solicitudes (en segundos)


# Datos del formulario
DATA="username=admin&password=password123"


# User-Agent para identificar las solicitudes de prueba
USER_AGENT="Testing Brute Force Detection Script"


echo "Enviando $NUMBER_OF_REQUESTS solicitudes a $URL..."


# Bucle para enviar solicitudes
for ((i=1; i<=NUMBER_OF_REQUESTS; i++))
do
 echo "Solicitud $i..."
 RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$URL" \
   -H "User-Agent: $USER_AGENT" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   --data "$DATA")
 echo "Código de estado HTTP: $RESPONSE"
  # Esperar antes de la próxima solicitud
 sleep $INTERVAL
done


echo "Prueba completada. Verifica las alertas en tu sistema Suricata."
