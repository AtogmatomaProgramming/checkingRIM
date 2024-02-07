
filterPorts <- function(df){
  f <- df[which(df[["PUERTO"]]%in%MY_PORTS),]
  return (f)
}

userInput <- function(prompt) {
  if (interactive()) {
    return(readline(prompt))
  } else {
    cat(prompt)
    return(readLines("stdin", n = 1))
  }
}

exportXlsFile <- function(wb, filename){
      openxlsx::saveWorkbook(wb, filename, overwrite = TRUE)
}

createHeadersXls <- function (lens) {
  check_headers<-aggregate(lens[,c("COD_ID"), ],
                           by=list(PUERTO=lens$PUERTO, FECHA_MUE=lens$FECHA_MUE,
                                   FECHA_DESEM=lens$FECHA_DESEM, CALADERO_DCF=lens$CALADERO_DCF,
                                   ARTE=lens$ARTE, ESTRATO_RIM=lens$ESTRATO_RIM, BARCO=lens$BARCO,
                                   TIPO_MUE=lens$COD_TIPO_MUE,N_RECHAZOS=lens$N_RECHAZOS), FUN=length)
  names(check_headers)<-c("PUERTO","FECHA_MUE","FECHA_DESEM","CALADERO_DCF","ARTE",
                          "ESTRATO_RIM","BARCO","TIPO_MUESTREO","N_RECHAZOS","N.mue.tallas")
  
  check_headers <- check_headers [
    with(check_headers, order(PUERTO, FECHA_DESEM, FECHA_MUE)),
  ]
  
  wb <- openxlsx::createWorkbook()
  
  name_worksheet <- paste("check_headers", YEAR, MONTH, sep = "_")
  
  openxlsx::addWorksheet(wb, name_worksheet)
  openxlsx::writeData(wb, name_worksheet, check_headers)
  
  Sys.setenv(R_ZIPCMD = "C:/Rtools/bin/zip.exe")
  
  filename <- file.path(DATA_PATH, paste0(name_worksheet, ".xlsx"))
  
  
  exportXlsFile(wb, filename)

}

createCatchesXls <- function(lens, catches){
  
  sampled_species <- lens[,c("COD_ID", "PUERTO", "FECHA_MUE", "BARCO", "ESP_MUE",
                                    "CATEGORIA", "ESP_CAT", "SEXO")]

  check_catches <- merge(catches, sampled_species, all.x = TRUE)
  check_catches <- check_catches[, c("COD_ID", "PUERTO", "FECHA_MUE", "BARCO", "ESP_MUE",
                                     "CATEGORIA", "ESP_CAT", "SEXO", "P_DESEM")]

  # generate pivot table
  pt <- PivotTable$new()
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
  
  wb <- createWorkbook(creator = Sys.getenv("USERNAME"))
  name_worksheet <- paste("check_catches", YEAR, MONTH, sep = "_")
  addWorksheet(wb, name_worksheet)
  setRowHeights(wb, name_worksheet, rows = nrow(pt_dataframe), heights = 15)
  setColWidths(wb, name_worksheet, cols = c(1:8), widths = c(12, 12, 15, 30, 30, 30, 3, 10))
  
  # I don't know why text rotation does not work:
  port_style <- createStyle(textRotation = 255)
  
  addStyle(wb, name_worksheet, port_style, rows = nrow(pt_dataframe), cols=1)
  
  pt$writeToExcelWorksheet(wb=wb, wsName=name_worksheet,
                           topRowNumber=1, leftMostColumnNumber=1,
                           applyStyles=TRUE, mapStylesFromCSS=TRUE)
  
  filename <- file.path(DATA_PATH, paste0(name_worksheet, ".xlsx"))
  exportXlsFile(wb, filename)
  
}

createLengthsXls <- function(lens){
  
  check_lengths <- lens %>%
    select(COD_ID, PUERTO, FECHA_MUE, BARCO, ESP_MUE, CATEGORIA, ESP_CAT, SEXO, INICIAL, FINAL, EJEM_MEDIDOS) %>%
    group_by(COD_ID, PUERTO, FECHA_MUE, BARCO, ESP_MUE, CATEGORIA, ESP_CAT, SEXO)%>%
    summarise(MIN=min(INICIAL), MAX=max(FINAL), SUM_EJEM_MEDIDOS = sum(EJEM_MEDIDOS))%>%
    arrange(PUERTO, FECHA_MUE, BARCO, ESP_MUE, CATEGORIA, ESP_CAT)
  
  # generate pivot table
  pt <- PivotTable$new()
  pt$addData(lens)
  pt$addRowDataGroups("PUERTO", addTotal=FALSE)
  pt$addRowDataGroups("FECHA_MUE", addTotal=FALSE)
  pt$addRowDataGroups("BARCO", addTotal=FALSE)
  pt$addRowDataGroups("ESP_MUE", addTotal=FALSE)
  pt$addRowDataGroups("CATEGORIA", addTotal=FALSE)
  pt$addRowDataGroups("ESP_CAT", addTotal=FALSE)
  pt$addRowDataGroups("SEXO", addTotal=FALSE)
  pt$defineCalculation(calculationName="T_MIN", summariseExpression="min(INICIAL)")
  pt$defineCalculation(calculationName="T_MAX", summariseExpression="max(FINAL)")
  pt$defineCalculation(calculationName="NUM_EJEM", summariseExpression="sum(EJEM_MEDIDOS)")
  pt$renderPivot()
  
  pt_dataframe <- pt$asDataFrame()
  
  wb <- createWorkbook(creator = Sys.getenv("USERNAME"))
  name_worksheet <- paste("check_lengths", YEAR, MONTH, sep = "_")
  addWorksheet(wb, name_worksheet)
  setRowHeights(wb, name_worksheet, rows = nrow(pt_dataframe), heights = 15)
  setColWidths(wb, name_worksheet, cols = c(1:8), widths = c(12, 12, 15, 30, 30, 30, 3, 10))
  
  # I don't know why text rotation does not work:
  port_style <- createStyle(textRotation = 255)
  
  addStyle(wb, name_worksheet, port_style, rows = nrow(pt_dataframe), cols=1)
  
  pt$writeToExcelWorksheet(wb=wb, wsName=name_worksheet,
                           topRowNumber=1, leftMostColumnNumber=1,
                           applyStyles=TRUE, mapStylesFromCSS=TRUE)
  # saveWorkbook(wb, file=file.path(DATA_PATH, paste0("check_lenghts_", YEAR, "_", MONTH, ".xlsx")), overwrite = TRUE)
  filename <- file.path(DATA_PATH, paste0(name_worksheet, ".xlsx"))
  exportXlsFile(wb, filename)
  
  
}

createCheckFilesXlsx <- function(capturas_tot, tallas){
  
  # clean data
  lens <- filterPorts(tallas)
  catches <- filterPorts(capturas_tot)
  catches <- catches[catches$COD_TIPO_MUE=="2",]
  
  #names of files
  files_paths <- lapply(c("check_headers","check_catches", "check_lengths"),
                        function(x){
                          f <- file.path(DATA_PATH, paste0(x, "_", YEAR, "_", MONTH, ".xlsx"))
                        }
  )
  files_paths <- unlist(files_paths, use.names = FALSE)
  
  if(any(file.exists(files_paths))){
    answer <-userInput("Some of the files already exists. Do you want to overwrite? (Y/N) ")
    if (answer %in% c("Y", "y")) {
      createHeadersXls(lens)
      createCatchesXls(lens, catches)
      createLengthsXls(lens)
      print("Files saved.")
    } else {
      print("Nothing is saved.")
    }
  } else {
    createHeadersXls(lens)
    createCatchesXls(lens, catches)
    createLengthsXls(lens)
    print("Files saved.")
  }
  
}
