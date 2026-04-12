#!/bin/bash
# =============================================================================
# Script: script2.sh
# Descripción: Itera sobre los archivos .v en hdl/ y sintetiza cada uno
#              con Vivado. Los reportes se guardan con el mismo nombre
#              del archivo .v pero con extensión .log
#              Los archivos pdk45 se omiten por no ser compatibles con Vivado.
#
# Uso: ./script2.sh
# =============================================================================

# Las funciones deben definirse primero antes de usarse
log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

# Buscar Vivado automáticamente en el sistema
VIVADO=$(which vivado 2>/dev/null)
if [ -z "$VIVADO" ]; then
    VIVADO=$(find /home -name "vivado" -path "*/bin/vivado" 2>/dev/null | head -1)
fi
if [ -z "$VIVADO" ]; then
    error "No se encontró Vivado. Verificá que esté instalado."
fi
log "Usando Vivado en: $VIVADO"

# Carpeta donde están los archivos .v
HDL_DIR="hdl"

# Carpeta donde se guardan los reportes
LOGS_DIR="logs"

log "Iniciando síntesis de sumadores..."

# --- Paso 1: Verificar que exista la carpeta hdl/ ----------------------------
if [ ! -d "$HDL_DIR" ]; then
    error "No existe la carpeta $HDL_DIR/. Ejecutá primero script1.sh"
fi

# --- Paso 2: Crear carpeta de logs si no existe ------------------------------
mkdir -p "$LOGS_DIR"

# --- Paso 3: Iterar sobre cada archivo .v y sintetizarlo ---------------------
for vfile in "$HDL_DIR"/*.v; do

    # Omitir archivos pdk45 ya que usan celdas ASIC no compatibles con Vivado
    if [[ "$vfile" == *"pdk45"* ]]; then
        log "Omitiendo $(basename $vfile) (archivo PDK45, no compatible con Vivado)"
        continue
    fi

    # Obtenemos el nombre del archivo sin extensión (ej: add8u_8KJ)
    basename=$(basename "$vfile" .v)

    # Extraemos el nombre real del módulo desde adentro del archivo .v
    # tomamos solo la primera línea con "module" por si hay varios módulos
    top_module=$(grep "^module " "$vfile" | head -1 | sed 's/module //;s/(.*//')

    log "Sintetizando $basename (módulo: $top_module)..."

    # Corremos Vivado en modo batch con el script TCL
    # Le pasamos el archivo .v y el nombre real del módulo
    "$VIVADO" -mode batch -source synth.tcl \
        -tclargs "$vfile" "$top_module" \
        > "$LOGS_DIR/$basename.log" 2>&1

    log "  Reporte guardado en logs/$basename.log"

done

log "¡Síntesis completada! Reportes disponibles en $LOGS_DIR/"
