## readCrisis.R
library(tidyverse); library(readxl); library(ggmap); library(leaflet)
library(htmltools); library(magrittr); library(feather)


#### Get data from sheets ####
path <- "C:/Users/joshh/TBD Solutions LLC/TBDS Files on Pedro - CR Consolidated Information/Crisis Facilities Searchable Master Database.xlsx"
#Please specify your own directory
df <- read_excel(path, sheet = "Data Table")

crisis_df <-
  df %>%
  rename_all(list(~str_to_lower(.))) %>%
  rename_all(list(~str_replace_all(.," |-","_"))) %>%
  # Remove columns with all NAs or 0s
  map(~.x) %>%
  discard(~all(is.na(.x)|.x == 0)) %>%
  map_df(~.x)

crisis_address <-
  crisis_df %>%
  filter(!is.na(address_1) & !is.na(city) & !is.na(zip)) %>%
  filter(
    !classification %in% c("State Psychiatric Hospital","Private Psychiatric Hospital")
  ) %>%
  mutate(
    location = paste0(address_1,", ",city,", ",state," ",zip)
  ) %>%
  select(name, location, operated_by, classification) 

# Register Google Geocoding API 
register_google(key = Sys.getenv("geocoding_api_key"), day_limit = 10000)

crisis_coords <- 
  crisis_address %>%
  mutate_geocode(
    location = location, 
    source = "google",
    output = "more", 
    messaging = T,
    override_limit = T
  )

rm(df)
write_feather(crisis_address, "data/crisis_address.feather")
write_feather(crisis_coords, "data/crisis_coords.feather")
write_feather(crisis_df, "data/crisis_df.feather")
