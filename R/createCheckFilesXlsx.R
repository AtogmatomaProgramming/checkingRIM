#' Function to create a xls file with the checked samples from SIRENO's database
#' @param capturas_tot: data frame returned by the importRIMCatches() or
#' importRIMFiles() functions.
#' @param tallas: lengths data frame returned by the importRIMCatchesInLengths () or
#' importRIMFiles() functions.
#' @return export all the previous xls files generated
#' @export
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
