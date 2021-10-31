#Read the csv and the shp
library(sf)
library(tidyverse)
NZ_territory<-st_read("F:/UCL/GIS/Week1/statsnzterritorial-authority-2018-generalised-SHP/territorial-authority-2018-generalised.shp")
NZ_employ<-read.csv("F:/UCL/GIS/Week1/Exam/Employee.csv",skip = 1)
#get the geometry of the graph
NZ_territory %>%
  st_geometry()%>%
  plot()
#join the data
NZ_territory<-NZ_territory%>%
  merge(.,
        NZ_employ,
        by.x="TA2018_V1_",
        by.y="Area_Code")
#Caution:if error: 'by' must specify a uniquely vaild column n
#shoule be careful about the data header.

#check this join
NZ_territory%>%
  head(., n=10)

#then plot the graph
library(tmap)
tmap_mode("plot")
NZ_territory%>%
  qtm(.,fill="Employed.Full.time")
#Write shape to a New Geopackage and give it a name
NZ_territory%>%
  st_write(.,"F:/ucl/gis/Week1/Exam/Exam1.gpkg",delete_layer=TRUE)
#check
library(reader)
library(RSQLite)
con<-dbConnect(RSQLite::SQLite(),
               dbname="F:/UCL/GIS/Week1/Exam/Exam1.gpkg")
con%>%
  dbListTables()

#add lol
