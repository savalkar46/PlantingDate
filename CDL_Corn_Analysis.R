library(tidyverse)
library(raster)
library(rgdal)
library(data.table)

## making list and extracting corn field pixels at value = 1

setwd("/home/supriya.savalkar/Planting_Date/Raster/")
list <- list.files("Washington",full.names = TRUE,pattern = ".tif$")
df <- data.table(rasterToPoints(raster(list[1])))
df <- cbind(df, Year=list[1], State = "Washington")
colnames(df)<-c("x", "y", "Layer_1","Year", "State")
df <- df |> filter(Layer_1 == 1)

i=2
n = length(list)
for (i in 2:n) {
  df_main <- data.table(rasterToPoints(raster(list[i])))
  df_main <- cbind(df_main, Year=list[i], State = "Washington")
  colnames(df_main)<-c("x", "y", "Layer_1","Year", "State")
  df_main <- df_main |> filter(Layer_1 == 1)
  df_final <- rbind(df,df_main)
  df <- df_final
}

count <- df |> group_by(Year, Layer_1) |> summarise(count=n())

count <- count |> pivot_wider(names_from = Layer_1, values_from = count)

write.csv(df, "/home/supriya.savalkar/Planting_Date/Raster/Output/Washington_Corn_2006_2021.csv")

write.csv(count, "/home/supriya.savalkar/Planting_Date/Raster/Output/Corn_Washington_count.csv")
