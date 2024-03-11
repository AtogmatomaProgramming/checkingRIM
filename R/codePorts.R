

#' This function gives you the codes of the ports what you are working.
#' You have two ways: using a vector with the name of the ports or insert
#' them by an emergent window
#' @param workingPorts vector with the names of our working ports
#' @param wayOfWork boolean paramater to choose if you work by the vector or the
#' emergent window way. By default is defined with TRUE value, because the main way of
#' work is throw a vector. Then, if you want to work introducing by hand the ports you only
#' need to declare wayOfWork with FALSE
#' @return the code of the selected working ports
#' @export


codePorts <- function(workingPorts, wayOfWork=TRUE){
  
  #Charging the sapmuebase's puerto dataframe
  comparativePorts <- sapmuebase::puerto
  comparativePorts$PUERTO <- toupper(comparativePorts$PUERTO)
  comparativePorts$PUERTO <- gsub(" ", "", comparativePorts$PUERTO)
  dfCheckPuerto <- ""
  
  if(wayOfWork){
    
    workingPorts <- gsub(" ", "", workingPorts)
    workingPorts <- toupper(workingPorts)
    dfIngresedPorts <- data.frame(PUERTO = workingPorts)
    dfCheckPuerto <- merge(dfIngresedPorts, comparativePorts, all.x =TRUE)
    dfCheckPuerto <- dfCheckPuerto[is.na(dfCheckPuerto$COD_PUERTO), ]
    
  } else {
    
    workingPorts <- dlgInput(message="Ingrese puertos de estudio separados por coma:")$res
    workingPorts <- gsub(" ", "", workingPorts)
    workingPorts <- strsplit(workingPorts, ",")
    workingPorts <- unlist(workingPorts)
    workingPorts <- toupper(workingPorts)
    dfIngresedPorts <- data.frame(PUERTO = workingPorts)
    dfCheckPuerto <- merge(dfIngresedPorts, comparativePorts, all.x =TRUE)
    dfCheckPuerto <- dfCheckPuerto[is.na(dfCheckPuerto$COD_PUERTO), ]
    
  }
  
  if(nrow(dfCheckPuerto)!=0){
    
    wrongPorts <- dfCheckPuerto$PUERTO
    wrongPorts <- paste(wrongPorts, collapse=", ")
    warningMessage = paste0("Ha insertado mal/no se encuentran los siguientes puertos: ", wrongPorts, " Por favor, revise los puertos utilizados")
    
    return(print(warningMessage))
    
  } else {
    
    filterCodPor <- comparativePorts[comparativePorts$PUERTO %in% workingPorts, ]
    portsCode <- as.vector(filterCodPor$COD_PUERTO)
    
  }
  
  return(portsCode)
  
}


