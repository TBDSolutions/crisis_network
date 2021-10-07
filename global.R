# Load fun, data, libs, source files
library(shinydashboard)
library(shinythemes)
library(DT)
library(tidyverse)
library(plotly)
library(lubridate)
library(RColorBrewer)
library(feather)
library(leaflet)
library(ggmap)
library(htmltools)

# crisis_address <- read_feather("data/crisis_address.feather")
crisis_coords <- read_feather("data/crisis_coords.feather")
crisis_network <- read_feather("data/crisis_df.feather")

crisis_address <- 
  crisis_coords %>%
  filter(!is.na(lon) & !is.na(name)) %>%
  mutate(name = str_trim(name)) %>%
  select(name:lat) %>%
  rename(type = classification)

factpal <- colorFactor("viridis", unique(crisis_address$type))
