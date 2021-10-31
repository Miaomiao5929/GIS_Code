#read the csv from last practical
mycsv<-read.csv("F:/UCL/GIS/Week1/Practical/fly-tipping-borough.csv")
#R will produce a list of objects that are currently active
ls()
#will remove the object A from the workspace
rm(A)
#create some datasets, first a vector of 1-100 and 101-200
Data1 <- c(1:100)
Data2 <- c(101:200)
#Plot the data
plot(Data1, Data2, col="red")
#just for fun, create some more, this time some normally distributed
#vectors of 100 numbers
Data3 <- rnorm(100, mean = 53, sd=34)
Data4 <- rnorm(100, mean = 64, sd=14)
#plot
plot(Data3, Data4, col="blue")
#plot using the data we have
df <- data.frame(Data1, Data2)
plot(df, col="green")
#If you have a very large data frame (thousands or millions of rows) it is useful to see only a selection of these. There are several ways of doing this:
#show the first 10 and then last 10 rows of data in df...
library(tidyverse)
df%>%
head()
df %>%
tail()
#dplyr is a grammar of data manipulation, it has multiple verbs that allow you to change your data into a suitable format.
library(dplyr)
df <- df %>%
  dplyr::rename(column1 = Data1, column2=Data2)
#To select or refer to columns directly by name, we can either use dplyr again!
df %>% 
  dplyr::select(column1)
#Open your new .csv file in Excel. There might be some non-numeric values inside numeric columns which will cause problems in your analysis. 
#To remove these, you can use the replace function in Excel. 
#In the home tab under â€˜Editingâ€? open up the find and replace dialogue box and enter the following into the find box
#read it into R
LondonDataOSK<- read.csv("F:/UCL/GIS/Week2/practical/prac2/ward-profiles-excel-version.csv", 
                         header = TRUE, 
                         sep = ",",  
                         encoding = "latin1")
# this is also another more straightforward way to read in files that was devloped in 2017 to make it more intuitive to find and load files using the here package. 
install.packages("here")
library(here)
here::here()
#Here we will use it to just read in a .csv file (directly from the web this time â€? read.csv can do this too) and clean text characters out from the numeric columns before they cause problems:
#skipping over the 'n/a' entries as you go...
LondonData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv",
                       locale = locale(encoding = "latin1"),
                       na = "n/a")
# check what data type your new data set is, we can use the class() function
class(LondonData)
#use the class() function (from base R) within another two functions summarise_all() (from dplyr) and pivot_longer() (from tidyr) to check that our data has been read in correctly
Datatypelist <- LondonData %>% 
  summarise(across(everything(),class)) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")

Datatypelist
#You should see that all columns that should be numbers are read in as numeric. Try reading in LondonData again, but this time without excluding the â€˜n/aâ€? values in the file
LondonData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv", 
                       locale = locale(encoding = "latin1"))
#you ever wish to quickly edit data, then use edit()
LondonData <- edit(LondonData)
#quickly and easily summarise the data or look at the column headers
summary(df)
# just look at the head, top5
LondonData%>%
  colnames()%>%
  head()
#Selecting rows
#Your borough data will probably be found between rows 626 and 658. Therefore we will first create a subset by selecting these rows into a new data frame and then reducing that data frame to just four columns. There are a few ways of doing this
#select just the rows we need by explicitly specifying the range of rows we need
LondonBoroughs<-LondonData[626:658,]
#We can also do this with dplyrâ€? with the slice() function, taking a â€œsliceâ€? out of the datasetâ€?
LondonBoroughs<-LondonData%>%
  slice(626:658)
#dplyr has a cool function called filter()that letâ€™s you subset rows based on conditionsâ€?
#filter based on a variable, for example extracting all the wards where female life expextancy is greather than 90.
Femalelifeexp<- LondonData %>% 
  filter(`Female life expectancy -2009-13`>90)
#we can use the function str_detect() from the stringr package in combination with filter() from dplyr. Both these packages are part of the tidyverse again
LondonBoroughs<- LondonData %>% 
  filter(str_detect(`New code`, "^E09"))
#Check it worked:
LondonBoroughs$`Ward name`
#That  also the same as
LondonBoroughs %>% 
  dplyr::select(`Ward name`) %>%
  print()
#The stringr package is really great and if you ever need to manipulate text type data then itâ€™s the place to start.
#This is because it features twice in the data set. Thatâ€™s fine, extract only unique rows with distinct(), again from dplyr:
#Selecting columns
#select columns 1,19,20 and 21
LondonBoroughs_manualcols<-LondonBoroughs[,c(1,19,20,21)]
#We can also replicate this with dplyr with select()
#select columns 1,19,20 and 21
LondonBoroughs_dplyrcols<-LondonBoroughs %>%
  dplyr::select(c(1,19,20,21))
#The c() function is also used here â€? this is the â€˜combineâ€? function â€? another very useful function in R which allows arguments (in this case, column reference numbers) into a single value.
#However, we could also again use a more â€˜data sciency wayâ€™â€¦selecting the columns that contain certain words â€?
LondonBoroughs_contains<-LondonBoroughs %>% 
  dplyr::select(contains("expectancy"), 
                contains("obese - 2011/12 to 2013/14"),
                contains("Ward name")) 
#Renaming columns
library(janitor)

LondonBoroughs <- LondonBoroughs %>%
  dplyr::rename(Borough=`Ward name`)%>%
  clean_names()
#If you wanted to now change it every word having a capital letter you would runâ€¦but donâ€™t do this now.
LondonBoroughs <- LondonBoroughs %>%
  #here the ., means all data
  clean_names(., case="big_camel")
#More dplyr verbs
#What about determining both:

#the average of male and female life expectancy together
#a normalised value for each London borough based on the London average.
# letâ€™s us add new variables based on existing onesâ€?
Life_expectancy <- LondonBoroughs %>%Life_expectancy <- LondonBoroughs %>% 
  #new column with average of male and female life expectancy
  mutate(averagelifeexpectancy= (female_life_expectancy_2009_13 +
                                   male_life_expectancy_2009_13)/2)%>%
  #new column with normalised life expectancy
  mutate(normalisedlifeepectancy= averagelifeexpectancy /
           mean(averagelifeexpectancy))%>%
  #select only columns we want
  dplyr::select(new_code,
                borough,
                averagelifeexpectancy, 
                normalisedlifeepectancy)%>%
  #arrange in descending order
  #ascending is the default and would be
  #arrange(normalisedlifeepectancy)
  arrange(desc(normalisedlifeepectancy)) 
  #new column with average of male and female life expectancy
  mutate(averagelifeexpectancy= (female_life_expectancy_2009_13 +
                                   male_life_expectancy_2009_13)/2)%>%
  Life_expectancy <- LondonBoroughs %>% 
  #new column with average of male and female life expectancy
  Life_expectancy <- LondonBoroughs %>% 
  #new column with average of male and female life expectancy
  Life_expectancy <- LondonBoroughs %>% 
  #new column with average of male and female life expectancy
  mutate(averagelifeexpectancy= (female_life_expectancy_2009_13 +
                                   male_life_expectancy_2009_13)/2)%>%
  #new column with normalised life expectancy
  mutate(normalisedlifeepectancy= averagelifeexpectancy /
           mean(averagelifeexpectancy))%>%
  #select only columns we want
  dplyr::select(new_code,
                borough,
                averagelifeexpectancy, 
                normalisedlifeepectancy)%>%
  #arrange in descending order
  #ascending is the default and would be
  #arrange(normalisedlifeepectancy)
  arrange(desc(normalisedlifeepectancy))
#We can also use dplyr to show us the top and bottom number of rows instead of using head or tail like we did earlier.
#top of data
slice_head(Life_expectancy, n=5)
#bottom of data
slice_tail(Life_expectancy,n=5)
#Levelling up withdplyr
# whereby if the value is greater than 81.16 we can assign the Borough a string of â€œabove UK averageâ€?, and if below a string of â€œbelow UK average
Life_expectancy2 <- Life_expectancy %>%
  mutate(UKcompare = case_when(averagelifeexpectancy>81.16 ~ "above UK average",
                               TRUE ~ "below UK average"))
Life_expectancy2
#Now whilst this is useful, it doesnâ€™t tell is much more about the data itself, what if we wanted to know the range of life expectancies for London Boroughs that are above the national averageâ€?.
Life_expectancy2_group <- Life_expectancy2 %>%
  mutate(UKdiff = averagelifeexpectancy-81.16) %>%
  group_by(UKcompare)%>%
  summarise(range=max(UKdiff)-min(UKdiff), count=n(), Average=mean(UKdiff))

Life_expectancy2_group
#but now what if we wanted to have more information based on the distribution of the Boroughs compared to the national average, as opposed to just over or underâ€?.there are a few ways to do this..
#Again work out difference between the life expectancy of the Boroughs compared to the national average
#Round the whole table based on if the column is numeric (this isnâ€™t required and weâ€™re not adding a new column). Here we are using across that applies some kind of transformation across the columns selected (or that are numeric in this case).
#Here we need to:
#1.Round the column UKdiff to 0 decimcal places (not adding a new column)
#2.Use case_when() to find Boroughs that have an average age of equal to or over 81 and create a new column that containts text based combining equal or above UK average by then the years created in UKdiff. We do this through the str_c() function from the stringr pacakge that letâ€™s us join two or more vector elements into a single character vector. Here sep determines how these two vectors are separated.
#3.Then group by the UKcompare column
#4.Finally, count the number in each group.
Life_expectancy3 <- Life_expectancy %>%
  mutate(UKdiff = averagelifeexpectancy-81.16)%>%
  mutate(across(where(is.numeric), round, 3))%>%
  mutate(across(UKdiff, round, 0))%>%
  mutate(UKcompare = case_when(averagelifeexpectancy >= 81 ~ 
                                 str_c("equal or above UK average by",
                                       UKdiff, 
                                       "years", 
                                       sep=" "), 
                               TRUE ~ str_c("below UK average by",
                                            UKdiff,
                                            "years",
                                            sep=" ")))%>%
  group_by(UKcompare)%>%
  summarise(count=n())

Life_expectancy3
#There is a lot of information here that we could use and make into a plot or map. 
# we could map the difference between the average life expectancy of each London Borough compared to the UK average..to do this would can just reuse some of the code from the example aboveâ€?.
Life_expectancy4 <- Life_expectancy %>%
  mutate(UKdiff = averagelifeexpectancy-81.16)%>%
  mutate(across(is.numeric, round, 3))%>%
  mutate(across(UKdiff, round, 0))
#Plotting
plot(LondonBoroughs$male_life_expectancy_2009_13,
     LondonBoroughs$percent_children_in_reception_year_who_are_obese_2011_12_to_2013_14)
#Pimp my graph!
#we can pimp this graph using something a bit more fancy than the base graphics functions. Here we will use plotly an open source interactive graphing libraryâ€?
install.packages("plotly")
library(plotly)
plot_ly(LondonBoroughs, 
        #data for x axis
        x = ~male_life_expectancy_2009_13, 
        #data for y axis
        y = ~percent_children_in_reception_year_who_are_obese_2011_12_to_2013_14, 
        #attribute to display when hovering 
        text = ~borough, 
        type = "scatter", 
        mode = "markers")
#Spatial Data in R
#The first package we need to install for this part of the practical is maptools â€“â€? either find and install it using the RStudio GUI or do the following:
install.packages("maptools")
#Making some choropleth maps
#So one mega cool thing about R is you can read spatial data in straight from the internetz! Try this below for downloading a GeoJson fileâ€¦it might take a few minutesâ€?
#Move either to your project folder and read it in. The .shp is normally quicker to load.
library(sf)
library(tidyverse)
EW <- st_read("https://opendata.arcgis.com/datasets/8edafbe3276d4b56aec60991cbddda50_2.geojson")
EW <- st_read("F:/UCL/GIS/Week2/practical/prac2/Local_Authority_Districts_(December_2015)_Boundaries/Local_Authority_Districts_(December_2015)_Boundaries.shp")
#We will look for the bit of the district code that relates to London (E09) from the â€˜lad15cdâ€? column data frame of our sf object.
LondonMap<- EW %>%
  filter(str_detect(lad15cd, "^E09"))

#plot it using the qtm function
library(tmap)
qtm(LondonMap)
#Attribute data
#we need to join some attribute data to some boundaries, letâ€™s do it with merge(), but first clean up all of our names with Janitor again.
library(janitor)
LondonData <- clean_names(LondonData)
#EW is the data we read in straight from the web
BoroughDataMap <- EW %>%
  clean_names()%>%
  # the . here just means use the data already loaded
  filter(str_detect(lad15cd, "^E09"))%>%
  merge(.,
        LondonData, 
        by.x="lad15cd", 
        by.y="new_code",
        no.dups = TRUE)%>%
  distinct(.,lad15cd, 
           .keep_all = TRUE)
#An alternative to merge() would be to use a left_join() (like in SQL)â€¦but itâ€™s the same thing as merge().
BoroughDataMap2 <- EW %>% 
  clean_names() %>%
  filter(str_detect(lad15cd, "^E09"))%>%
  left_join(., 
            LondonData,
            by = c("lad15cd" = "new_code"))
#Simple mapping
#We can create a choropleth map very quickly now using qtm() as weâ€™ve done before
library(tmap)
library(tmaptools)
tmap_mode("plot")
qtm(BoroughDataMap, 
    fill = "rate_of_job_seekers_allowance_jsa_claimants_2015")
#We are going to need to create a box (termed bounding box) around London using the st_box() function from the sf package to extract the basemap image (which is a raster).
install.packages("OpenStreetMap")
tmaplondon <- BoroughDataMap %>%
  st_bbox(.) %>% 
  tmaptools::read_osm(., type = "osm", zoom = NULL)
#style â€? how to divide the data into out colour breaks
#palette â€? the colour scheme to use
tmap_mode("plot")

tm_shape(tmaplondon)+
  tm_rgb()+
  tm_shape(BoroughDataMap) + 
  tm_polygons("rate_of_job_seekers_allowance_jsa_claimants_2015", 
              style="jenks",
              palette="YlOrBr",
              midpoint=NA,
              title="Rate per 1,000 people",
              alpha = 0.5) + 
  tm_compass(position = c("left", "bottom"),type = "arrow") + 
  tm_scale_bar(position = c("left", "bottom")) +
  tm_layout(title = "Job seekers' Allowance Claimants", legend.position = c("right", "bottom"))
#But remember our Life_expectancy4 data that we wrangled earlier. Can you think of a way to map this? So we need to
#Merge our Life_expectancy4map with the spatial data EW
Life_expectancy4 <- Life_expectancy %>%
  mutate(UKdiff = averagelifeexpectancy-81.16)%>%
  mutate(across(is.numeric, round, 3))%>%
  mutate(across(UKdiff, round, 0))

Life_expectancy4map <- EW %>%
  merge(.,
        Life_expectancy4, 
        by.x="lad15cd", 
        by.y="new_code",
        no.dups = TRUE)%>%
  distinct(.,lad15cd, 
#Map our merge with tmap
tmap_mode("plot")

tm_shape(tmaplondon)+
  tm_rgb()+
  tm_shape(Life_expectancy4map) + 
  tm_polygons("UKdiff", 
              style="pretty",
              palette="Blues",
              midpoint=NA,
              title="Number of years",
              alpha = 0.5) + 
  tm_compass(position = c("left", "bottom"),type = "arrow") + 
  tm_scale_bar(position = c("left", "bottom")) +
  tm_layout(title = "Difference in life expectancy", legend.position = c("right", "bottom"))
#Facing tidy data
flytipping <- read_csv("https://data.london.gov.uk/download/fly-tipping-incidents/536278ff-a391-4f20-bc79-9e705c9b3ec0/fly-tipping-borough.csv")
# we can also do something like this to force the columns to the appopraite data types (e.g. text, numberic)
flytipping1 <- read_csv("https://data.london.gov.uk/download/fly-tipping-incidents/536278ff-a391-4f20-bc79-9e705c9b3ec0/fly-tipping-borough.csv", 
                        col_types = cols(
                          code = col_character(),
                          area = col_character(),
                          year = col_character(),
                          total_incidents = col_number(),
                          total_action_taken = col_number(),
                          warning_letters = col_number(),
                          fixed_penalty_notices = col_number(),
                          statutory_notices = col_number(),
                          formal_cautions = col_number(),
                          injunctions = col_number(),
                          prosecutions = col_number()
                        ))
## view the data
view(flytipping1)
#convert the tibble into a tidy tibble
flytipping_long <- flytipping1 %>% 
  pivot_longer(
    cols = 4:11,
    names_to = "tipping_type",
    values_to = "count"
  )
# view the data
view(flytipping_long)
#an alternative which just pulls everything out into a single table
flytipping2 <- flytipping1[,1:4]
#pivot the tidy tibble into one that is suitable for mapping
flytipping_wide <- flytipping_long %>% 
  pivot_wider(
    id_cols = 1:2,
    names_from = c(year,tipping_type),
    names_sep = "_",
    values_from = count)

view(flytipping_wide)
#what if you were just interested in a specific varaible and wanted the coloums to be each year of the dataâ€¦again using pivot_wider()
widefly <- flytipping2 %>% 
  pivot_wider(
    names_from = year, 
    values_from = total_incidents)


