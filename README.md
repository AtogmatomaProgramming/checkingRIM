# Script para generar los ficheros excel usados en el chequeo de los muestreos MT2 de RIM.

Se crean los ficheros para chequear:
- cabeceras de los muestreos (check_headers_2022_01.xlsx)
- pesos desembarcados por categoría (check_catches_2022_01.xlsx)
- tallas (check_lengths_2022_01.xlsx)


Cada fichero contiene los campos necesarios que hay que comprobar manualmente 
para considerar los muestreos chequeados.


El script necesita dos de los informes 'tallas por up' que se obtienen del SIRENO.
En concreto:
- capturas (IEOUPMUEDESTOT.TXT)
- capturas de especies medidas (IEOUPDESTAL.TXT)


La estructura de las carpetas para que el script funcione adecuadamente es:
 ↳ (carpeta donde se encuentra el script)
     ↳ data
        ↳ YEAR
            ↳ YEAR_MONTH
Siendo YEAR el año y MONTH el mes en dígitos. Por ejemplo:


![Ejemplo de estructura de la carpetas.](./assets/folders_example.png)



Los informes 'tallas por up' deben estar en la carpeta YEAR_MONTH.


Los ficheros generados se guardan en la carpeta YEAR_MONTH.


