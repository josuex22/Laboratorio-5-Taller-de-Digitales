#!/bin/bash
# =============================================================================
# Script: script3.sh
# Descripción: Lee los reportes de síntesis en logs/ y extrae los valores de
#              Slice LUTs y Slice Registers de cada uno, generando un archivo
#              CSV con los resultados.
#              Los archivos pdk45 se omiten por no haber sido sintetizados.
#
# Uso: ./script3.sh
# =============================================================================

# Carpeta donde están los logs
LOGS_DIR="logs"

# Nombre del archivo CSV de salida
CSV_FILE="resultados.csv"

log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

log "Generando archivo CSV con resultados..."

# --- Paso 1: Verificar que exista la carpeta logs/ ---------------------------
if [ ! -d "$LOGS_DIR" ]; then
    error "No existe la carpeta $LOGS_DIR/. Ejecutá primero script2.sh"
fi

# --- Paso 2: Crear el encabezado del CSV -------------------------------------
echo "Modulo,Slice LUTs,Slice Registers" > "$CSV_FILE"

# --- Paso 3: Iterar sobre cada log y extraer los valores ---------------------
for logfile in "$LOGS_DIR"/*.log; do

    # Omitir archivos pdk45 ya que no fueron sintetizados
    if [[ "$logfile" == *"pdk45"* ]]; then
        log "Omitiendo $(basename $logfile) (archivo PDK45)"
        continue
    fi

    # Obtenemos el nombre del módulo sin extensión
    modulo=$(basename "$logfile" .log)

    # Extraemos el valor de Slice LUTs del log
    luts=$(grep "| Slice LUTs\*" "$logfile" | awk '{print $5}')

    # Extraemos el valor de Slice Registers del log
    regs=$(grep "| Slice Registers" "$logfile" | head -1 | awk '{print $5}')

    # Escribimos la línea en el CSV
    echo "$modulo,$luts,$regs" >> "$CSV_FILE"

    log "  $modulo -> LUTs: $luts, Registers: $regs"

done

log "¡CSV generado exitosamente en $CSV_FILE!"
