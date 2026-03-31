#!/bin/bash
# =============================================================================
# Script: script1.sh
# Descripción: Descarga el repositorio de sumadores aproximados, copia los
#              archivos .v al directorio hdl/ en la raíz del proyecto
#              y elimina los demás contenidos del repositorio clonado.
#
# =============================================================================

REPO_URL="https://github.com/ehw-fit/evoapproxlib.git"   # URL del repositorio
REPO_SUBPATH="adders/8_unsigned/pareto_pwr_ep"            # Carpeta dentro del repo que nos interesa
REPO_DIR="evoapproxlib"                                    # Nombre de la carpeta donde se clona el repo
HDL_DIR="hdl"                                              # Carpeta destino para los archivos .v

log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

log "Iniciando setup del proyecto..."

# --- Paso 1: Clonar el repositorio -------------------------------------------
log "Clonando repositorio..."
git clone --depth=1 --filter=blob:none --sparse "$REPO_URL" "$REPO_DIR" \
    || error "No se pudo clonar el repositorio."

# --- Paso 2: Carpeta a descargar ---------------------------
cd "$REPO_DIR" || error "No se pudo entrar al directorio $REPO_DIR."
git sparse-checkout set "$REPO_SUBPATH" \
    || error "No se pudo configurar sparse-checkout."
cd ..

# --- Paso 3: Crear la carpeta hdl/ -------------------------------------------
log "Creando directorio $HDL_DIR/..."
mkdir -p "$HDL_DIR"

# --- Paso 4: Copiar los archivos .v a hdl/ -----------------------------------
log "Copiando archivos .v a $HDL_DIR/..."
V_FILES=$(find "$REPO_DIR/$REPO_SUBPATH" -name "*.v")

if [ -z "$V_FILES" ]; then
    error "No se encontraron archivos .v en $REPO_DIR/$REPO_SUBPATH."
fi

COUNT=0
for f in $V_FILES; do
    cp "$f" "$HDL_DIR/"
    log "  Copiado: $(basename $f)"
    COUNT=$((COUNT + 1))
done

log "Total de archivos .v copiados: $COUNT"

# --- Paso 5: Limpiar el repositorio clonado ----------------------------------
log "Eliminando repositorio temporal ($REPO_DIR)..."
rm -rf "$REPO_DIR"

log "¡Setup completado! Los archivos están disponibles en $HDL_DIR/"
