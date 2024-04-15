#' Function to create a xlsx file with the lengths sampling document from SIRENO's database
#' @param lengths: lengths data frame returned by the importRIMLengths() or
#' importRIMFiles() functions.
#' @return a new table in xls format to see the data in a different format
#' where de values of the columns turns to the rows and reversal
#' @export
create_lengths_xlsx <- function(lengths, year, month, path = getwd()) {
  check_lengths <- lengths %>%
    select(COD_ID, PUERTO, FECHA_MUE, BARCO, ESP_MUE, CATEGORIA, ESP_CAT, SEXO, INICIAL, FINAL, EJEM_MEDIDOS) %>%
    group_by(COD_ID, PUERTO, FECHA_MUE, BARCO, ESP_MUE, CATEGORIA, ESP_CAT, SEXO) %>%
    summarise(MIN = min(INICIAL), MAX = max(FINAL), SUM_EJEM_MEDIDOS = sum(EJEM_MEDIDOS)) %>%
    arrange(PUERTO, FECHA_MUE, BARCO, ESP_MUE, CATEGORIA, ESP_CAT)

  # generate pivot table
  pt <- pivottabler::PivotTable$new()
  pt$addData(lengths)
  pt$addRowDataGroups("PUERTO", addTotal = FALSE)
  pt$addRowDataGroups("FECHA_MUE", addTotal = FALSE)
  pt$addRowDataGroups("BARCO", addTotal = FALSE)
  pt$addRowDataGroups("ESP_MUE", addTotal = FALSE)
  pt$addRowDataGroups("CATEGORIA", addTotal = FALSE)
  pt$addRowDataGroups("ESP_CAT", addTotal = FALSE)
  pt$addRowDataGroups("SEXO", addTotal = FALSE)
  pt$defineCalculation(calculationName = "T_MIN", summariseExpression = "min(INICIAL)")
  pt$defineCalculation(calculationName = "T_MAX", summariseExpression = "max(FINAL)")
  pt$defineCalculation(calculationName = "NUM_EJEM", summariseExpression = "sum(EJEM_MEDIDOS)")
  pt$renderPivot()

  pt_dataframe <- pt$asDataFrame()

  wb <- openxlsx::createWorkbook(creator = Sys.getenv("USERNAME"))
  name_worksheet <- paste("check_lengths", year, month, sep = "_")
  openxlsx::addWorksheet(wb, name_worksheet)
  openxlsx::setRowHeights(wb, name_worksheet, rows = nrow(pt_dataframe), heights = 15)
  openxlsx::setColWidths(wb, name_worksheet, cols = c(1:8), widths = c(12, 12, 15, 30, 30, 30, 3, 10))

  # I don't know why text rotation does not work:
  port_style <- openxlsx::createStyle(textRotation = 255)

  openxlsx::addStyle(wb, name_worksheet, port_style, rows = nrow(pt_dataframe), cols = 1)

  pt$writeToExcelWorksheet(
    wb = wb, wsName = name_worksheet,
    topRowNumber = 1, leftMostColumnNumber = 1,
    applyStyles = TRUE, mapStylesFromCSS = TRUE
  )

  filename <- file.path(path, paste0(name_worksheet, ".xlsx"))
  export_xls_file(wb, filename)
}
