# checkingRIM
Package to create xlsx files to ease the manual checking of the data stored
in SIRENO database.

# Install
With devtools package installed:
```
library(devtools)
install_github("Eucrow/checkingRIM")
```

## Description
The package contains the function create_check_files_xlsx(), which create three
xlsx files with the headers, catches and lengths data ready to check. _**Every
file contains the fields that must be manually verified in order to consider
the sampling properly checked.**_

Documentation of the function is available with: `?create_check_files_xlsx`

### Files created
The files are saved with the names:
- check_headers_YEAR_MONTH.xlsx
- check_catches_YEAR_MONTH.xlsx
- check_lengths_YEAR_MONTH.xlsx
where YEAR is the year of the data and MONTH is the month of the data.

For example:
- check_headers_2022_01.xlsx
- check_catches_2022_01.xlsx
- check_lengths_2022_01.xlsx

**_Every file contains the fields that must be manually verified in order to consider
the sampling checked._**

### Usage
```
create_check_files_xlsx(
  catches,
  catches_in_lengths,
  ports,
  year,
  month,
  dialog = FALSE,
  path = getwd()
)
```

### Arguments
- *catches*: SIRENO's catches report from ICES project.
- *catches_in_lengths*: SIRENO's 'catches in lengths' report from ICES project.
- *ports*: vector with the code ports to filter.
- *year*: year of the data. This is used only to name the exported files.
This function doesn't filter by year.
- *month*: month of the data. This is used only to name the exported files.
This function doesn't filter by month.
- *dialog*: logical. If TRUE, a dialog box is showed to select the ports.
If FALSE, the ports are selected from the argument 'ports'. FALSE by default.
- *path*: path where the catches and lengths are located and where the
exported files will be saved.

### Files required
The function requires the catches and 'catches in lengths' SIRENO reports:
- catches: IEOUPMUEDESTOT.TXT
- catches in lengths: IEOUPMUEDESTAL.TXT
This reports must be downloaded from SIRENO:
```
Informes
   ↳ Listados
      ↳ Ficheros Planos
         ↳ Muestreos Tallas (UP)
```

### Filter data
Besides of the 'year' and 'month' parameters, this function doesn't filter by
year or month. The exported files contains all the data of the input files.
The 'year' and 'month' parameters are used only to name the exported files.

## Example
Example using the variable 'ports'

```r
library(checkingRIM)

MY_PORTS <- c("Santoña", "San Vicente de la Barquera", "Llanes", "Suances", "Santander")

create_check_files_xlsx("IEOUPMUEDESTOTMARCO.TXT",
                        "IEOUPMUEDESTALMARCO.TXT",
                        puertos = MY_PORTS,
                        "2024",
                        "01",
                        path = "results/2024/2024_01")

```
Example using the emergent window:

```r
library(checkingRIM)

create_check_files_xlsx("IEOUPMUEDESTOTMARCO.TXT",
                        "IEOUPMUEDESTALMARCO.TXT",
                        "2024",
                        "01",
                        dialog = TRUE,
                        path = "results/2024/2024_01")

```



