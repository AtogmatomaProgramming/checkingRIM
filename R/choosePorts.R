
#' Give the user the option of choose the working ports writing them in an
#' emergent window
#' @return the code of the selected working ports
#' @export


choosePorts <- function(){
  
  ports <- dlgInput(message="Ingrese puertos de estudio (Formato: SANTOÑA,VIVEIRO,...):")$res
  ports <- gsub(" ", "", ports)
  ports <- strsplit(ports, ",")
  ports <- unlist(ports)
  ports <- toupper(ports)
  dfIngresedPorts <- data.frame(PUERTO = ports)
  comparativePorts <- sapmuebase::puerto
  comparativePorts$PUERTO <- toupper(comparativePorts$PUERTO)
  comparativePorts$PUERTO <- gsub(" ", "", comparativePorts$PUERTO)
  dfCheckPuerto <- merge(dfIngresedPorts, comparativePorts, all.x =TRUE)
  dfCheckPuerto <- dfCheckPuerto[is.na(dfCheckPuerto$COD_PUERTO), ]
  
  if(nrow(dfCheckPuerto)!=0){
    
    badPorts <- dfCheckPuerto$PUERTO
    badPorts <- paste(badPorts, collapse=", ")
    warningMessage = paste0("Ha insertado mal/no se encuentran los siguientes puertos: ", badPorts, " Por favor, insértelos de nuevo correctamente")
    ports <- dlgInput(message=warningMessage)$res
    ports <- gsub(" ", "", ports)
    ports <- strsplit(ports, ",")
    ports <- unlist(ports)
    ports <- toupper(ports)
    
    filterCodPor <- comparativePorts[comparativePorts$PUERTO %in% ports, ]
    portsCode <- as.vector(filterCodPor$COD_PUERTO)
    
  } else {
    
    filterCodPor <- puertos[puertos$PUERTO %in% ports, ]
    portsCode <- as.vector(filterCodPor$COD_PUERTO)
    
  }
  
  return(portsCode)
  
}


