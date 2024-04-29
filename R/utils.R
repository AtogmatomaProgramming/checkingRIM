#' Filter data frame by port.
#'
#' @details Variable "COD_PUERTO" is needed in the data frame.
#' @param df data frame to filter.
#' @param cod_ports vector with the code of ports to filter.
#' @return data frame filtered by ports.
#' @noRd
filter_ports <- function(df, cod_ports) {
  f <- df[which(df[["COD_PUERTO"]] %in% cod_ports), ]
  if (nrow(f) == 0 || is.na(nrow(f))) {
    print("ERROR. Los puertos usados para filtrar no se encuentran en el dataframe dado.")
    winDialog(type = "ok", "ERROR. Los puertos usados para filtrar no se encuentran en el dataframe dado.")
  } else {
    return(f)
  }
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
user_input <- function(prompt) {
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
#' @param file_name path and file name of the data to export.
#' @noRd
export_xls_file <- function(wb, file_name) {
  openxlsx::saveWorkbook(wb, file_name, overwrite = TRUE)
}


#' Dialog box to select ports.
#' Show an emergent window with the list of available ports and
#' manage its logic.
#'
#' @return vector with the codes of the working ports
#' @noRd
manage_dialog_box <- function() {
  ports <- as.vector(sapmuebase::puerto$PUERTO)
  answer <- TRUE
  while (answer) {
    selected_ports <- svDialogs::dlgList(ports,
      multiple = TRUE,
      title = "PUERTOS"
    )

    if (length(selected_ports$res) == 1) {
      warning_message <- winDialog(
        type = "yesno",
        message = "Solo ha seleccionado un puerto. ¿Desea continuar?"
      )
      if (warning_message != "NO") {
        answer <- FALSE
      }
    } else {
      answer <- FALSE
    }
  }

  ports <- as.vector(selected_ports$res)
  ports <- as.vector(sapmuebase::puerto[sapmuebase::puerto$PUERTO %in% ports, "COD_PUERTO"])
}
