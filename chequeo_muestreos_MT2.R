# CHECK MT2 SAMPLES ----

## INSTRUCTIONS ----------------------------------------------------------------
# This script create 3 xlsx files used to manual checking of MT2 samples:
# - file to check headers of the samples: check_headers_YEAR_MONTH.xlsx
# - file to check catches of the samples: check_catches_YEAR_MONTH.xlsx
# - file to check lengths of the samples: check_lengths_YEAR_MONTH.xlsx
#
# Every xlsx file contain the mandatory variables which must be manually checked.
#
# The scripts needs the SIRENO reports:
# - catches 
# - catches in lengths
#
# The folder structure use in this script is:
# ↳ folder containing this script
#     ↳ data
#         ↳ YEAR
#            ↳ YEAR_MONTH
#
# The SIRENO files must be stored in the YEAR_MONTH folder.
#
# The xlsx files created by this script will be saved in the YEAR_MONTH folder.




## LIBRARIES --------------------------------------------------------------------
library(sapmuebase)
library(dplyr)
library(openxlsx)
library(pivottabler)
source("functions.R")

## YOU ONLY HAVE TO CHANGE THIS VARIABLES ---------------------------------------

YEAR <- "2022"
MONTH <- "01"

FILENAME_DES_TOT <- paste0("IEOUPMUEDESTOTMARCO.TXT")
FILENAME_DES_TAL <- paste0("IEOUPMUEDESTALMARCO.TXT")

MY_PORTS <- c("Santoña", "San Vicente de la Barquera", "Llanes", "Suances", "Santander")

## GLOBAL VARIABLES - DON'T CHANGE IT -------------------------------------------
PATH_FILES <- paste0(getwd(), YEAR, "/", MONTH)
DATA_PATH <- paste0(getwd(),"/data/", YEAR, "/", YEAR, "_", MONTH)

## IMPORT DATA
capturas_tot <- importRIMCatches(FILENAME_DES_TOT, path = DATA_PATH)
tallas <- importRIMCatchesInLengths(FILENAME_DES_TAL, path = DATA_PATH)

# CREATE FILES
createCheckFilesXlsx(capturas_tot, tallas)
