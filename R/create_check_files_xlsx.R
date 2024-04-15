#' Function to create a xls file with the checked samples from SIRENO's database
#'
#' @description
#' This function creates three xlsx files with the headers, catches and lengths data ready to check.
#'
#' The files are saved in the path 'path' with the names 'check_headers_YEAR_MONTH.xlsx',
#' 'check_catches_YEAR_MONTH.xlsx' and 'check_lengths_YEAR_MONTH.xlsx', where
#' YEAR is the year of the data and MONTH is the month of the data.
#'
#' Besides of the 'year' and 'month' parameters, this function doesn't filter by
#' year or month. The exported files contains all the data of the input files.
#' The 'year' and 'month' parameters are used only to name the exported files.
#'
#' @param capturas_tot data frame returned by the importRIMCatches() or
#' importRIMFiles() functions.
#' @param tallas lengths data frame returned by the importRIMCatchesInLengths () or
#' importRIMFiles() functions.
#' @param puertos vector with the code ports to filter.
#' @param year year of the data. This is used only to name the exported files. This function doesn't filter by year.
#' @param month month of the data. This is used only to name the exported files. This function doesn't filter by month.
#' @param dialog logical. If TRUE, a dialog box is showed to select the ports. If FALSE, the ports are
#' selected from the vector 'puertos'.
#' @param path path where the capturas_tot and tallas are located and where the exported files are saved.
#' @return export all the xlsx files generated
#' @export
create_check_files_xlsx <- function(capturas_tot, tallas, puertos, year, month, dialog = FALSE, path = getwd()) {

  if (is.null(puertos)) {
    dialog <- TRUE
  }


  if (dialog) {
    ports <- manage_dialog_box()
  } else {
    ports <- encode_ports(puertos)
  }

  # import data
  capturas_tot <- sapmuebase::importRIMCatches(capturas_tot, path = path)
  tallas <- sapmuebase::importRIMCatchesInLengths(tallas, path = path)

  # clean data
  lengths <- filter_ports(tallas, ports)
  catches <- filter_ports(capturas_tot, ports)
  catches <- catches[catches$COD_TIPO_MUE == "2", ]


  # names of files
  files_paths <- lapply(
    c("check_headers", "check_catches", "check_lengths"),
    function(x) {
      return(file.path(path, paste0(x, "_", year, "_", month, ".xlsx")))
    }
  )
  files_paths <- unlist(files_paths, use.names = FALSE)

  if (any(file.exists(files_paths))) {
    answer <- user_input("Some of the files already exists. Do you want to overwrite? (Y/N) ")
    if (answer %in% c("Y", "y")) {
      create_headers_xlsx(lengths, year, month, path)
      create_catches_xlsx(catches, lengths, year, month,path)
      create_lengths_xlsx(lengths, year, month, path)
      print("Files saved.")
    } else {
      print("Nothing is saved.")
    }
  } else {
    create_headers_xlsx(lengths, year, month, path)
    create_catches_xlsx(lengths, year, month, catches, path)
    create_lengths_xlsx(lengths, year, month, path)
    print("Files saved.")
  }
}
