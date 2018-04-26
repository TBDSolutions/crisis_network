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

# Please specify your own directory where CRU_address.feather file exists
# If there is no such feather file, run readCRU.R automatically...

CRU_address <- read_feather("data/CRU_address.feather")

CRU_address <- CRU_address %>%
  filter(!is.na(lon)) %>%
  filter(!is.na(Name)) %>%
  mutate(Name = trimws(Name))

factpal <- colorFactor("Accent", unique(CRU_address$Urban_Rural))
