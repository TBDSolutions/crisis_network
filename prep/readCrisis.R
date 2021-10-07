## readCrisis.R
library(tidyverse); library(readxl); library(ggmap); library(leaflet)
library(htmltools); library(magrittr); library(feather)


#### Get data from sheets ####

crisis <- read_excel("data/crisis_facilities_20181001.xlsx", sheet = 1)
crisis <- crisis[,2:8]
crisis$type <- "Crisis Facility"

psych <- read_excel("data/crisis_facilities_20181001.xlsx", sheet = 6)
psych <- psych[,2:8]
psych$type <- "Private Psychiatric Hospitals"

lock_csu <- read_excel("data/crisis_facilities_20181001.xlsx", sheet = 9)
lock_csu <- lock_csu[,2:8]
lock_csu$type <- "Locked CSU"

# crisis_stab <- read_excel("data/crisis_facilities.xlsx", sheet = 4)
# crisis_stab <- crisis_stab[,2:8]
# crisis_stab$type <- "Crisis Stabilization"

# twentythree <- read_excel("data/crisis_facilities.xlsx", sheet = 5)
# twentythree <- twentythree[,2:8]
# twentythree$type <- "23-Hour Crisis Stabilization"

peer_respite <- read_excel("data/crisis_facilities_20181001.xlsx", sheet = 11)
peer_respite <- peer_respite[,2:8]
peer_respite$type <- "Peer Respite"

youth_cru <- read_excel("data/crisis_facilities_20181001.xlsx", sheet = 10)
youth_cru <- youth_cru[,2:8]
youth_cru$type <- "Youth CRU"

crisis_network <-
crisis %>%
  bind_rows(psych, lock_csu, peer_respite, youth_cru) # , crisis_stab, twentythree

# Remove extra dataframes

rm(youth_cru);rm(peer_respite);rm(twentythree);rm(crisis_stab);rm(lock_csu);
rm(psych);rm(crisis)

#### Get geocodes

crisis_address <-
  crisis_network %>%
  select(
    Name,
    Location,
    Phone,
    Operated = `Operated by`,
    type
  ) %>%
  filter(is.na(Location) == F)

# 
register_google(
  key = rstudioapi::askForPassword("Enter Google Maps API key:"),
  day_limit = 10000
)

crisis_coords <- 
  geocode(
    crisis_address$Location, 
    source = "google",
    output = "more", 
    messaging = T,
    override_limit = T
  )

crisis_address %<>% bind_cols(crisis_coords)

factpal <- colorFactor("viridis", unique(crisis_address$type))

write_feather(crisis_address, "data/crisis_address.feather")
write_feather(crisis_coords, "data/crisis_coords.feather")
write_feather(crisis_network, "data/crisis_network.feather")
