
# Análisis ratio EEG MUSE
## Diego Garrido Cerpa - Viña del Mar

# Cargar librería (opcional para manipulación)
library(dplyr)

# Leer el archivo
s1 <- read.csv("spectral_data_s1_1to20Hz.csv", header = TRUE)

# Verificar estructura
head(s1)

# Calcular promedios
theta_mean <- s1 %>%
  slice(4:8) %>%       # Filas 4 a 8 Hz (theta)
  summarise(across(everything(), mean))

alpha_mean <- s1 %>%
  slice(8:12) %>%      # Filas 8 a 12 Hz (alpha)
  summarise(across(everything(), mean))

# Crear nuevo dataframe con dos filas: theta y alpha
result <- rbind(
  Theta = theta_mean,
  Alpha = alpha_mean
)

# Mostrar resultado
print(result)


















library(dplyr)

# Lista para guardar resultados
resultados <- list()

# Bucle para los 8 participantes
for (i in 1:8) {
  
  # Nombre de archivo
  file_name <- paste0("spectral_data_s", i, "_1to20Hz.csv")
  
  # Leer el archivo
  df <- read.csv(file_name, header = TRUE)
  
  # Eliminar columna de frecuencia
  df <- df %>% select(-Frequency_Hz)
  
  # Calcular promedios
  theta_mean <- df %>%
    slice(4:8) %>%
    summarise(across(everything(), mean))
  
  alpha_mean <- df %>%
    slice(8:12) %>%
    summarise(across(everything(), mean))
  
  # Crear dataframe con nombres diferenciadores
  temp <- rbind(
    setNames(theta_mean, names(theta_mean)),
    setNames(alpha_mean, names(alpha_mean))
  )
  
  rownames(temp) <- c(paste0("Theta_s", i), paste0("Alpha_s", i))
  
  # Guardar en la lista
  resultados[[i]] <- temp
}

# Combinar todos en un solo dataframe
final_df <- do.call(rbind, resultados)

# Mostrar resultado
print(final_df)

# Si quieres exportarlo a CSV
write.csv(final_df, "mean_band_participants.csv", row.names = TRUE)





# Creamos un nuevo dataframe con los ratios
ratio_df <- data.frame()

# Iterar de 1 a 8 (participantes)
for (i in 1:8) {
  
  # Extraer las dos filas de este sujeto
  theta_row <- final_df[paste0("Theta_s", i), ]
  alpha_row <- final_df[paste0("Alpha_s", i), ]
  
  # Calcular ratios
  ta_ratio <- theta_row / alpha_row  # Theta / Alpha
  at_ratio <- alpha_row / theta_row  # Alpha / Theta
  
  # Asignar nombres
  rownames(ta_ratio) <- paste0("T/A_s", i)
  rownames(at_ratio) <- paste0("A/T_s", i)
  
  # Agregar al nuevo dataframe
  ratio_df <- rbind(ratio_df, ta_ratio, at_ratio)
}

# Ver resultado
print(ratio_df)

# Si quieres guardarlo
write.csv(ratio_df, "ThetaAlpha_ratios.csv", row.names = TRUE)






