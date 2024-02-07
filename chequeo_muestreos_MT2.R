# CHECK MT2 SAMPLES ------------------------------------------------------------
## INSTRUCTIONS ----------------------------------------------------------------
# Script para generar los ficheros excel usados en el chequeo de los muestreos MT2 de RIM.
#
# Puedes encontrar instrucciones más detalladas en el fichero README.md.
# 
# Se crean los ficheros para chequear:
#   - cabeceras de los muestreos (check_headers_2022_01.xlsx)
#   - pesos desembarcados por categoría (check_catches_2022_01.xlsx)
#   - tallas (check_lengths_2022_01.xlsx)
# 
# Cada fichero contiene los campos necesarios que hay que comprobar manualmente 
# para considerar los muestreos chequeados.
# 
# El script necesita dos de los informes 'tallas por up' que se obtienen del SIRENO.
# En concreto:
#   - capturas (IEOUPMUEDESTOT.TXT)
#   - capturas de especies medidas (IEOUPDESTAL.TXT)
# 
# La estructura de las carpetas para que el script funcione adecuadamente es:
#   ↳ (carpeta donde se encuentra el script)
#       ↳ data
#           ↳ YEAR
#               ↳ YEAR_MONTH
#
# Siendo YEAR el año y MONTH el mes en dígitos.
#
# Por ejemplo, la ruta del archivo de cabeceras del mes de enero de 2022 sería:
# data/2022/2022_01/check_headers_2022_01.xlsx. 
#
# Puedes ver una imagen de cómo sería esta estructura de carpetas en el archivo
# /assets/folders_example.png.
#
# Los informes 'tallas por up' deben estar en la carpeta YEAR_MONTH.
# 
# Los ficheros generados se guardan en la carpeta YEAR_MONTH.


## LIBRARIES --------------------------------------------------------------------
library(sapmuebase)
library(dplyr)
library(openxlsx)
library(pivottabler)
source("functions.R")


## YOU ONLY HAVE TO CHANGE THIS VARIABLES ---------------------------------------
# Year to check
YEAR <- "2022"

# Month to check, in digits.
MONTH <- "01"

# File names of SIRENO reports
FILENAME_DES_TOT <- paste0("IEOUPMUEDESTOTMARCO.TXT")
FILENAME_DES_TAL <- paste0("IEOUPMUEDESTALMARCO.TXT")

# Ports you want to check. Pay attention to spelling.
MY_PORTS <- c("Santoña", "San Vicente de la Barquera", "Llanes", "Suances", "Santander")


## GLOBAL VARIABLES - DON'T CHANGE IT -------------------------------------------
PATH_FILES <- paste0(getwd(), YEAR, "/", MONTH)
DATA_PATH <- paste0(getwd(),"/data/", YEAR, "/", YEAR, "_", MONTH)


## IMPORT DATA
capturas_tot <- importRIMCatches(FILENAME_DES_TOT, path = DATA_PATH)
tallas <- importRIMCatchesInLengths(FILENAME_DES_TAL, path = DATA_PATH)


# CREATE FILES
createCheckFilesXlsx(capturas_tot, tallas)
