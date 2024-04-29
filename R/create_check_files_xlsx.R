#' Function to create a xls file with the checked samples from SIRENO's database
#'
#' @description
#' This function creates three xlsx files with the headers, catches and lengths
#' data ready to check.
#'
#' The files are saved in the path 'path' with the names 'check_headers_YEAR_MONTH.xlsx',
#' 'check_catches_YEAR_MONTH.xlsx' and 'check_lengths_YEAR_MONTH.xlsx', where
#' YEAR is the year of the data and MONTH is the month of the data.
#'
#' The ports for which the files are created are selected by 'port' argument or by
#' an emergent window with a list of ports. Is possible to select multiple ports
#' in this window using the 'ctrl' key of the keyboard and click with the mouse.
#'
#' Besides of the 'year' and 'month' parameters, this function doesn't filter by
#' year or month. The exported files contains all the data of the input files.
#' The 'year' and 'month' parameters are used only to name the exported files.
#'
#' @param catches SIRENO's catches report from ICES project.
#' @param catches_in_lengths SIRENO's 'catches in lengths' report from ICES project.
#' @param year year of the data. This is used only to name the exported files.
#' This function doesn't filter by year.
#' @param month month of the data. This is used only to name the exported files.
#' This function doesn't filter by month.
#' @param ports vector with the code ports for which the files will be created.
#' @param dialog logical. If TRUE, a dialog box is showed to select the ports.
#' If FALSE, the ports are selected from the argument 'ports'. FALSE by default.
#' @param path path where the catches and lengths are located and where the
#' exported files will be saved.
#' @export
create_check_files_xlsx <- function(catches,
                                    catches_in_lengths,
                                    year,
                                    month,
                                    ports = c(),
                                    dialog = FALSE,
                                    path = getwd()) {
  if (length(ports) == 0) {
    dialog <- TRUE
  }

  if (dialog) {
    ports <- manage_dialog_box()
    if (length(ports) == 0) {
      return("No file was created")
    }
  } else {
    ports <- encode_ports(ports)
  }

    # import data
    catches <- sapmuebase::importRIMCatches(catches, path = path)
    lengths <- sapmuebase::importRIMCatchesInLengths(catches_in_lengths, path = path)

    # clean data
    lengths <- filter_ports(lengths, ports)
    catches <- filter_ports(catches, ports)
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
        create_catches_xlsx(catches, lengths, year, month, path)
        create_lengths_xlsx(lengths, year, month, path)
        print("Files saved.")
      } else {
        print("Nothing is saved.")
      }
    } else {
      create_headers_xlsx(lengths, year, month, path)
      create_catches_xlsx(catches, lengths, year, month, path)
      create_lengths_xlsx(lengths, year, month, path)
      print("Files saved.")
    }

}
