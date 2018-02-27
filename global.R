# Load fun, data, libs, source files
library(shinydashboard)
library(shinythemes)
library(DT)
library(ggplot2)
library(dygraphs) 
library(parsetR)
library(visNetwork)
library(d3heatmap)
library(dplyr)
library(forcats)
library(magrittr)
library(tidyr)
library(broom)
library(googlesheets)
library(plotly)
library(xts)
library(lubridate)
library(RColorBrewer)
library(car)
library(feather)
library(leaflet)
library(readxl)
library(ggmap)
library(htmltools)

crisis_address <- read_feather("data/crisis_address.feather")
crisis_coords <- read_feather("data/crisis_coords.feather")
crisis_network <- read_feather("data/crisis_network.feather")

crisis_address <- crisis_address %>%
  filter(is.na(lon) == F) %>%
  filter(is.na(Name) == F) %>%
  mutate(Name = trimws(Name))

factpal <- colorFactor("viridis", unique(crisis_address$type))