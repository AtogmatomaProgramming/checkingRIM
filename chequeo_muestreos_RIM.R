# CHECK MT2 SAMPLES ------------------------------------------------------------
## INSTRUCTIONS ----------------------------------------------------------------
# Script para generar los ficheros excel usados en el chequeo de los muestreos
# MT2 de RIM.
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
# El script necesita dos de los informes 'tallas por up' que se obtienen del
# SIRENO.
# En concreto:
#   - capturas (IEOUPMUEDESTOT.TXT)
#   - capturas de especies medidas (IEOUPDESTAL.TXT)
#
# La estructura de las carpetas para que el script funcione adecuadamente es:
#   ↳ (carpeta donde se encuentra el script)
#       ↳ data
#           ↳ year
#               ↳ YEAR_MONTH
#
# Siendo year el año y month el mes en dígitos.
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


## LIBRARIES -------------------------------------------------------------------
# library(sapmuebase)
library(dplyr)
# library(openxlsx)
# library(pivottabler)
# library(svDialogs)
# source("R/utils.R")
# source("R/create_check_files_xlsx.R")
# source("R/create_headers_xlsx.R")
# source("R/create_lengths_xlsx.R")
# source("R/create_catches_xlsx.R")
# source("R/encode_ports.R")

library(checkingRIM)


# Ports to check. Pay attention to spelling.
MY_PORTS <- c("Santoña", "San Vicente de la Barquera", "Llanes", "Suances",
              "Santander")

# Path where the input files are stored and the xlsx files will be saved:
DATA_PATH <- paste0(getwd(), "/results/", year, "/", year, "_", month)

## CREATE FILES ----------------------------------------------------------------
create_check_files_xlsx("IEOUPMUEDESTOTMARCO.TXT",
                        "IEOUPMUEDESTALMARCO.TXT",
                        puertos = MY_PORTS,
                        "2024",
                        "01",
                        # dialog = TRUE,
                        path = file.path(getwd(),
                        "results/2024/2024_01"))
