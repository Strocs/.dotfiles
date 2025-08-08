#!/bin/bash
# Este script lanza una ventana de PowerShell con privilegios de administrador
# para deshabilitar "Large Send Offload (LSO) v4" en los adaptadores vEthernet.
# La ventana se cerrará automáticamente al finalizar.

# Comando de PowerShell a ejecutar en la ventana de administrador.
# El 'Exit' al final asegura que la ventana de PowerShell se cierre después de ejecutar el comando.
CMD_TO_RUN="get-NetAdapterAdvancedProperty -Name vEthernet* | ? DisplayName -like 'Large Send Offload*v4*' | Set-NetAdapterAdvancedProperty -DisplayValue 'Disabled'; Exit"

# PowerShell espera que el comando codificado esté en formato UTF-16LE.
# Convertimos el comando a UTF-16LE y luego lo codificamos en Base64.
# El '-w 0' para base64 asegura que no haya saltos de línea en el output.
ENCODED_CMD=$(echo "$CMD_TO_RUN" | iconv -t UTF-16LE | base64 -w 0)

# Lanza powershell.exe, que a su vez lanza otra instancia de powershell.exe como administrador (-Verb RunAs).
# La nueva instancia ejecuta el comando codificado y luego se cierra.
pwsh.exe -Command "Start-Process pwsh.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -EncodedCommand ${ENCODED_CMD}'"

