#' Function to create a xls file with the catches sampling document from SIRENO's database
#' @param catches: data frame returned by the importRIMCatches() or
#' importRIMFiles() functions.
#' @param lengths: lengths data frame returned by the importRIMLengths() or
#' importRIMFiles() functions.
#' @return a new table in xls format to see the data in a diferent format
#' where de values of the columns turns to the rows and vice versa
#' @export
create_catches_xlsx <- function(catches, lengths, year, month, path = getwd()) {

  sampled_species <- lengths[, c("COD_ID", "PUERTO", "FECHA_MUE", "BARCO", "ESP_MUE",
                                 "CATEGORIA", "ESP_CAT", "SEXO")]

  check_catches <- merge(catches, sampled_species, all.x = TRUE)
  check_catches <- check_catches[, c("COD_ID", "PUERTO", "FECHA_MUE", "BARCO", "ESP_MUE",
                                     "CATEGORIA", "ESP_CAT", "SEXO", "P_DESEM")]

  # generate pivot table
  pt <- pivottabler::PivotTable$new()
  pt$addData(check_catches)
  pt$addRowDataGroups("PUERTO", addTotal=FALSE)
  pt$addRowDataGroups("FECHA_MUE", addTotal=FALSE)
  pt$addRowDataGroups("BARCO", addTotal=FALSE)
  pt$addRowDataGroups("ESP_MUE", addTotal=FALSE)
  pt$addRowDataGroups("CATEGORIA", addTotal=FALSE)
  pt$addRowDataGroups("ESP_CAT", addTotal=FALSE)
  pt$addRowDataGroups("SEXO", addTotal=FALSE)
  pt$defineCalculation(calculationName="P_DESEM", summariseExpression="sum(P_DESEM)")
  pt$renderPivot()

  pt_dataframe <- pt$asDataFrame()

  wb <- openxlsx::createWorkbook(creator = Sys.getenv("USERNAME"))
  name_worksheet <- paste("check_catches", year, month, sep = "_")
  openxlsx::addWorksheet(wb, name_worksheet)
  openxlsx::setRowHeights(wb, name_worksheet, rows = nrow(pt_dataframe), heights = 15)
  openxlsx::setColWidths(wb, name_worksheet, cols = c(1:8), widths = c(12, 12, 15, 30, 30, 30, 3, 10))

  # I don't know why text rotation does not work:
  port_style <- openxlsx::createStyle(textRotation = 255)

  openxlsx::addStyle(wb, name_worksheet, port_style, rows = nrow(pt_dataframe), cols = 1)

  pt$writeToExcelWorksheet(wb = wb, wsName = name_worksheet,
                           topRowNumber = 1, leftMostColumnNumber = 1,
                           applyStyles = TRUE, mapStylesFromCSS = TRUE)

  filename <- file.path(path, paste0(name_worksheet, ".xlsx"))
  export_xls_file(wb, filename)

}
