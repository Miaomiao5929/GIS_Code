library(tidyverse)
library(here)
library(janitor)
#read the csv and the shp
report<-read.csv(here("Exam","Report_Card_Assessment_Data_2018-19_School_Year.csv"))
library(sf)
shape<-st_read(here("Exam","Washington_Counties_with_Natural_Shoreline___washsh_area.shp"))
#Filter
county_only <- report %>%
  clean_names()%>%
  select(county, test_subject, percent_met_standard)%>%
  filter(county != "Multiple")%>%
  filter(test_subject == "Science") %>%
  #slice(101:120,)
  filter(percent_met_standard != "Suppressed: N<10")%>%
  filter(percent_met_standard != "No Students")%>%
  filter(str_detect(percent_met_standard, "^<", negate = T))%>%
  mutate(percent_met_standard = str_replace_all(percent_met_standard, pattern = c('%' = "")))%>%
  mutate(percent_met_standard2= as.numeric(percent_met_standard))%>%
  group_by(county)%>%
  summarise(average_met=mean(percent_met_standard2, na.rm=T))

shape
joined_data <- shape %>% 
  clean_names() %>%
  left_join(., 
            county_only,
            by = c("countylabe" = "county"))

library(tmap)
library(tmaptools)

bbox_county <- shape %>%
  st_bbox(.) %>% 
  tmaptools::read_osm(., type = "esri", zoom = NULL)

tm_shape(bbox_county)+
  tm_rgb()+
  
  
  tm_shape(joined_data) + 
  tm_polygons("average_met", 
              style="pretty",
              palette="Blues",
              midpoint=NA,
              #title="Number of years",
              alpha = 0.5) + 
  tm_compass(position = c("left", "bottom"),type = "arrow") + 
  tm_scale_bar(position = c("left", "bottom")) +
  tm_layout(title = "Difference in life expectancy", legend.position = c("right", "bottom"))



