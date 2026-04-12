# =============================================================================
# Script: synth.tcl
# Descripción: Script de TCL para sintetizar un archivo .v con Vivado.
#              Recibe el archivo .v y genera un reporte de utilización.
#
# =============================================================================

# Obtenemos los argumentos que le pasamos desde el script de Bash
set vfile [lindex $argv 0]   ;# archivo .v a sintetizar
set top   [lindex $argv 1]   ;# nombre del módulo top

# Indicamos la FPGA objetivo (Nexys A7)
set part "xc7a100tcsg324-1"

# Leemos el archivo .v
read_verilog $vfile

# Sintetizamos indicando el módulo top y la FPGA
synth_design -top $top -part $part

# Generamos el reporte de utilización
report_utilization

# Cerramos el Vivado
exit
