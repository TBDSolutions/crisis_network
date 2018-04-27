## readCrisis.R
library(tidyverse); library(readxl); library(ggmap); library(leaflet)
library(htmltools); library(magrittr); library(feather)


#### Get data from sheets ####

#Please specify your own directory
CRU_network <- read_excel("data/Michigan CRUs (Adult and Youth).xlsx")

# Rename column names
names(CRU_network)[names(CRU_network) == 'Crisis Program'] <- 'Name'
names(CRU_network)[names(CRU_network) == 'Operated by'] <- 'Operated_by'
names(CRU_network)[names(CRU_network) == 'Address'] <- 'Location'
names(CRU_network)[names(CRU_network) == 'Adult or Youth'] <- 'Adult_Youth'
names(CRU_network)[names(CRU_network) == 'Urban or Rural'] <- 'Urban_Rural'

#### Get geocodes

CRU_address <-
  CRU_network %>%
  select(
    Name,
    Location,
    Operated_by,
    Adult_Youth,
    Urban_Rural) %>%
  filter(is.na(Location) == F)

CRU_coords <- geocode(CRU_address$Location)

CRU_address %<>%
  bind_cols(CRU_coords)

na_location <- CRU_address$lon %>% is.na() %>% sum()
Max_Rep <- 10 #prevent while loop to repeat infinitely by restricting the maximum repitition time

#repeatedly do geocode until there is no NA values for lon & lat
while( na_location > 0){
  Max_Rep <- Max_Rep - 1
  missing_loc <- which(CRU_address$lon %>% is.na())
  for(i in 1:na_location){
    x <- CRU_address$Location[missing_loc[i]] %>%
      geocode()
    CRU_address$lon[missing_loc[i]] = x$lon
    CRU_address$lat[missing_loc[i]] = x$lat
  }
  na_location <- CRU_address$lon %>% is.na() %>% sum()
  if(Max_Rep == 0) break
}

remove(x)

write_feather(CRU_address, "data/CRU_address.feather")
write_feather(CRU_coords, "data/CRU_coords.feather")
write_feather(CRU_network, "data/CRU_network.feather")
