#' Filter data frame by port.
#'
#' @details Variable "COD_PUERTO" is needed in the data frame.
#' @param df data frame to filter.
#' @param cod_ports vector with the code ports to filter.
#' @return data frame filtered by port.
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
#'
#' @details
#' Function where through a dialog box it is possible to select ports
#' instead using a vector. Ctrl + left click allows select more than one.
#' @param master_data_port the master data port "PUERTO" from sapmuebase
#' @return the code of the selected ports
#' @noRd
manage_dialog_box <- function(master_data_ports) {
  list_port <- as.vector(master_data_ports$PUERTO)
  answer <- TRUE
  while (answer) {
    selected_ports <- dlgList(list_port,
      multiple = TRUE,
      title = "PUERTOS TRABAJO"
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

  work_ports <- as.vector(selected_ports$res)
  codes_work_ports <- as.vector(master_data_ports[master_data_ports$PUERTO %in% work_ports, "COD_PUERTO"])
}
