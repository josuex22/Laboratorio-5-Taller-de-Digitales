#!/bin/bash
# =============================================================================
# Script: script4.sh
# Descripción: Ejecuta todos los scripts del proyecto en orden automáticamente.
#              1. Descarga y organiza los sumadores (script1.sh)
#              2. Sintetiza los sumadores con Vivado (script2.sh)
#              3. Genera el CSV con los resultados (script3.sh)
#
# Uso: ./script4.sh
# =============================================================================

log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

log "=== Iniciando flujo completo ==="

# --- Paso 1: Descargar y organizar los sumadores -----------------------------
log "Ejecutando script1.sh..."
./script1.sh || error "Falló script1.sh"

# --- Paso 2: Sintetizar los sumadores ----------------------------------------
log "Ejecutando script2.sh..."
./script2.sh || error "Falló script2.sh"

# --- Paso 3: Generar el CSV --------------------------------------------------
log "Ejecutando script3.sh..."
./script3.sh || error "Falló script3.sh"

log "=== Flujo completado exitosamente ==="
