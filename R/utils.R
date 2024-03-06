#' Filter data frame by port.
#'
#' @detail Variable "PUERTO" is needed in the data frame.
#' @param df data frame to filter.
#' @return data frame filtered by port.
#' @noRd
filterPorts <- function(df){
  f <- df[which(df[["PUERTO"]]%in%MY_PORTS),]
  return (f)
}


#' Receive response of the input user to the prompt.
#'
#' @details
#' The prompt is showed and the code is stopped, waiting for the response of the
#' user. When the response is done, the code continue running and the content
#' of the response is returned.
#'
#' @param prompt Message to show in the command line.
#' @return Character read from the response of the user.
#' @noRd
userInput <- function(prompt) {
  if (interactive()) {
    return(readline(prompt))
  } else {
    cat(prompt)
    return(readLines("stdin", n = 1))
  }
}


#' Export workbook to xls file.
#'
#' @param wb workbook object from workbook package.
#' @param filename path and file name of the data to export.
#' @noRd
exportXlsFile <- function(wb, filename){
  openxlsx::saveWorkbook(wb, filename, overwrite = TRUE)
}
