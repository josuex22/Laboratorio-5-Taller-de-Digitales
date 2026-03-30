# Laboratorio-5-Taller-de-Digitales

## Integrantes
- Arce Cruz Josué 
- Navarro Acuña Mauro Agustin
- Arguedas Guzman Gabriel

## Estructura del Laboratorio
- `script1.sh`: Descarga de sumadores y organizacion en archivo "hdl"
- `script2.sh`: Sintetiza los .v
- `script3.sh`: Genera el .csv con la información (LUTs, Registers)
- `script4.sh`: Ejecuta todo aumaticamente

## Uso
Sintetizar distintos sumadores aproximados para una xc7a100tcsg324-1 (Nexys A7)
mediante el uso de scripting para automatización.

### 1. Clonar el repositorio del proyecto
```bash
git clone https://github.com/josuex22/Laboratorio-5-Taller-de-Digitales.git
cd Laboratorio-5-Taller-de-Digitales
```

### 2. Darle permisos a los scripts (solo la primera vez)
```bash
chmod +x script1.sh script2.sh script3.sh script4.sh
```

### 3. Ejecutar script1 para descargar los sumadores
```bash
./script1.sh
```
Esto descarga los 11 sumadores aproximados y los guarda en `hdl/`

### 4. Ejecutar script2 para sintetizar los sumadores
```bash
./script2.sh
```

### 5. Ejecutar script3 para generar el CSV con resultados
```bash
./script3.sh
```

### 6. O ejecutar todo de una sola vez con script4
```bash
./script4.sh
```


