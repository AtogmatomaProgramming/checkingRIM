#' Return the codes of the given ports.
#' There are two ways: using a vector with the name of the ports or select
#' them by an emergent window.
#' @param ports vector with the names of ports
#' @param dialog_box boolean parameter. If TRUE, the emergent window is showed.
#' If FALSE, the 'ports' argument must be given. FALSE by default.
#' @return vector with the code of the ports.
#' @export
encode_ports <- function(ports, dialog_box = FALSE) {

  master_ports <- sapmuebase::puerto

  if (dialog_box) {
    code_ports <- manage_dialog_box()
  } else {
    master_ports$PUERTO <- toupper(master_ports$PUERTO)
    master_ports$PUERTO <- gsub(" ", "", master_ports$PUERTO)
    input_ports <- data.frame(PUERTO = ports)
    input_ports$PUERTO <- toupper(input_ports$PUERTO)
    input_ports$PUERTO <- gsub(" ", "", input_ports$PUERTO)
    wrong_ports <- merge(input_ports, master_ports, all.x = TRUE)
    wrong_ports <- wrong_ports[is.na(wrong_ports$COD_PUERTO), ]

    if (nrow(wrong_ports) != 0) {
      wrong_ports <- wrong_ports$PUERTO
      wrong_ports <- paste(wrong_ports, collapse = ", ")
      warningMessage <- paste0("No se encuentran los siguientes puertos en el maestro de puertos: ", wrong_ports)

      print(warningMessage)
    } else {
      code_ports <- as.vector(master_ports[master_ports$PUERTO %in% input_ports$PUERTO, "COD_PUERTO"])
    }
  }
}
