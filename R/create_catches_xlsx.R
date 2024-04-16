#' Create xlsx file with data of catches as a resume to check the information.
#' @param catches: catches data frame returned by the importRIMCatches() function.
#' @param catches_in_lengths: catches in lengths data frame returned by the
#' importRIMCatchesInLengths() function.
#' @param year year of the data. This is used only to name the exported files.
#' This function doesn't filter by year.
#' @param month month of the data. This is used only to name the exported files.
#' This function doesn't filter by month.
#' @param path path where the 'catches' file is located and where the exported
#' files will be saved.
#' @export
create_catches_xlsx <- function(catches, catches_in_lengths, year, month, path = getwd()) {

  sampled_species <- catches_in_lengths[, c("COD_ID", "PUERTO", "FECHA_MUE", "BARCO", "ESP_MUE",
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
