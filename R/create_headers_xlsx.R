#' Create xlsx file with data of headers of samples as a resume to check the information.
#' @param lengths: lengths data frame returned by the importRIMLengths() function.
#' @param year year of the data. This is used only to name the exported files.
#' This function doesn't filter by year.
#' @param month month of the data. This is used only to name the exported files.
#' This function doesn't filter by month.
#' @param path path where the 'lengths' files is located and where the exported
#' files will be saved.
#' @export
create_headers_xlsx <- function(lengths, year, month, path = getwd()) {
  check_headers <- aggregate(lengths[, c("COD_ID"), ],
                             by = list(PUERTO = lengths$PUERTO, FECHA_MUE = lengths$FECHA_MUE,
                                       FECHA_DESEM = lengths$FECHA_DESEM, CALADERO_DCF = lengths$CALADERO_DCF,
                                       ARTE = lengths$ARTE, ESTRATO_RIM = lengths$ESTRATO_RIM, BARCO = lengths$BARCO,
                                       TIPO_MUE = lengths$COD_TIPO_MUE,N_RECHAZOS = lengths$N_RECHAZOS), FUN = length)
  names(check_headers) <- c("PUERTO", "FECHA_MUE", "FECHA_DESEM", "CALADERO_DCF", "ARTE",
                          "ESTRATO_RIM", "BARCO", "TIPO_MUESTREO", "N_RECHAZOS", "N.mue.tallas")

  check_headers <- check_headers [
    with(check_headers, order(PUERTO, FECHA_DESEM, FECHA_MUE)),
  ]

  wb <- openxlsx::createWorkbook()

  name_worksheet <- paste("check_headers", year, month, sep = "_")

  openxlsx::addWorksheet(wb, name_worksheet)
  openxlsx::writeData(wb, name_worksheet, check_headers)

  filename <- file.path(path, paste0(name_worksheet, ".xlsx"))

  export_xls_file(wb, filename)

}
