
#' Give the user the option of choose the working ports writing them in an
#' emergent window
#' @return the code of the selected working ports
#' @export


choosePorts <- function(){
  
  ports <- dlgInput(message="Ingrese puertos de estudio (Formato: Santoña, Viveiro, ...):")$res
  ports <- unlist(str_split(ports, pattern =  ", "))
  dfIngresedPorts <- data.frame(PUERTO = ports)
  puertos <- puerto
  puertos$TESTIGO <- "T"
  dfCheckPuerto <- merge(dfIngresedPorts, puertos, all.x =TRUE)
  dfCheckPuerto <- dfCheckPuerto[is.na(dfCheckPuerto$TESTIGO), ]
  
  if(nrow(dfCheckPuerto)!=0){
    
    badPorts <- dfCheckPuerto$PUERTO
    badPorts <- str_c(badPorts, collapse = ", ")
    warningMessage = paste0("Ha insertado mal los siguientes puertos: ", badPorts, ". Por favor, insértelos de nuevo correctamente")
    ports <- dlgInput(message=warningMessage)$res
    ports <- unlist(str_split(ports, pattern =  ", "))
    
    filterCodPor <- puertos[puertos$PUERTO %in% ports, ]
    portsCode <- as.vector(filterCodPor$COD_PUERTO)
    
  } else {
    
    filterCodPor <- puertos[puertos$PUERTO %in% ports, ]
    portsCode <- as.vector(filterCodPor$COD_PUERTO)
    
  }
  
  return(portsCode)
  
}


