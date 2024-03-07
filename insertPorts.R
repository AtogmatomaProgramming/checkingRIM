install.packages("svDialogs") # Para instalar el paquete
library(svDialogs)# Para usar el paquete
library(stringr)
library(utils)

my_name <- dlgInput(message="Ingrese puertos de estudio:")$res
my_niu_name <- unlist(str_split(my_name, pattern =  ", "))
df_checkpuertos <- data.frame(PUERTO = my_niu_name)
puertos <- puerto
puertos$TESTIGO <- "T"
nom_puertos <- puertos$PUERTO
nom_puertos <- str_c(nom_puertos, collapse = ", ")
df_fusion_puertos <- merge(df_checkpuertos, puertos, all.x =TRUE)
df_mal <- df_fusion_puertos[is.na(df_fusion_puertos$TESTIGO), ]

if(nrow(df_mal)!=0){
  warningMessage = paste0("Ha insertado mal uno de los puertos. Por favor, ingréselo de nuevo. Recuerde los nombres de los puertos son los siguientes. Busque el suyo para comprobar que lo escribe correctamente: 
                          ", nom_puertos)
  
  winDialog(message= warningMessage)
  
}