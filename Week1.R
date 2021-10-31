#read datas
 library(sf)
 shape <- st_read("F:/UCL/GIS/Week1/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")
#check and summary my datas
summary(shape)
#plot diagrams it will show all diagrams 
 plot(shape)
#Only need the geometry(outline of the shape)
library(sf)
shape %>% 
  st_geometry() %>%
  plot()
#read the edited csv did in excel
mycsv <-  read_csv("F:/UCL/GIS/Week1/F.csv")  
#As the first row is not the data i need so i need to skip 1 row
mycsv <- read_csv("F:/UCL/GIS/Week1/F.csv", skip = 1)
#To view the data just input:
mycsv
#Join the .csv to the shapefile. Here, replace Row Labels with whatever your GSS_CODE is called in the .csv
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE", 
        by.y="Row Labels")
#Check the merge was successful, this is just going to show the top 10 rows
shape%>%
  head(., n=10)
#But check what your coloumn name is from the adove code head(shape, n=10) it might be slightly different like 2011-2012 or x2011_2012¡­.
#check SUB...
library(tmap)
tmap_mode("plot")
# change the fill to your column name if different
shape %>%
  qtm(.,fill = "2019-20")
#Export data
shape %>%
  st_write(.,"F:/UCL/GIS/Week1/Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)
#then shows:Deleting layer `london_boroughs_fly_tipping' using driver `GPKG'
#Writing layer `london_boroughs_fly_tipping' to data source 
 # `F:/UCL/GIS/Week1/Rwk1.gpkg' using driver `GPKG'
#Writing 33 features with 17 fields and geometry type Multi Polygon.
#Now examine what is in the .gpkg¡­you can see that i¡¯ve already got my original_csv stored within the .gpkg as when i developed this practical i made sure it was working!
 con <- dbConnect(RSQLite::SQLite(),dbname="F:/UCL/GIS/Week1/Rwk1.gpkg",
                   +                  +              "london_boroughs_fly_tipping",)
 con %>%
  +     dbListTables()
 con %>%
  +     dbListTables()
#Add your .csv and disconnect from the .gpkg:
 con %>%
  +     dbWriteTable(.,
                     +                  "original_csv",
                     +                  mycsv,
                     +                  overwrite=TRUE)

   con %>% 
  +     dbDisconnect()

####Important Details####
library(sf)
library(tmap) 
library(tmaptools)
library(RSQLite)
library(tidyverse)
#read in the shapefile

shape <- st_read(
  "C:/Users/Andy/OneDrive - University College London/Teaching/CASA0005/2020_2021/CASA0005repo/Prac1_data/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")
# read in the csv
mycsv <- read_csv("C:/Users/Andy/OneDrive - University College London/Teaching/CASA0005/2020_2021/CASA0005repo/Prac1_data/fly_tipping_borough_edit.csv")  
# merge csv and shapefile
shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE", 
        by.y="Row Labels")
# set tmap to plot
tmap_mode("plot")
# have a look at the map
qtm(shape, fill = "2011_12")
# write to a .gpkg
shape %>%
  st_write(.,"C:/Users/Andy/OneDrive - University College London/Teaching/CASA0005/2020_2021/CASA0005repo/Prac1_data/Rwk1.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)
# connect to the .gpkg
con <- dbConnect(SQLite(),dbname="C:/Users/Andy/OneDrive - University College London/Teaching/CASA0005/2020_2021/CASA0005repo/Prac1_data/Rwk1.gpkg")
# list what is in it
con %>%
  dbListTables()
# add the original .csv
con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)
# disconnect from it
con %>% 
  dbDisconnect()

