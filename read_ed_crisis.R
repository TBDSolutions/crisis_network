# Read ED and Crisis locations for MDHHS project map

library(tidyverse); library(ggmap); library(leaflet); library(htmltools)

crisis_ed_address <- 
  read_csv("data/crisis_ed_locations.csv",col_types = cols(ZIP = "c")) %>%
  rename_all(funs(tolower)) %>%
  mutate(
    full_address = paste0(address,", ",city,", ",state," ",zip)
  )

# Register Google Geocoding API 
register_google(key = Sys.getenv("geocoding_api_key"), day_limit = 10000)

crisis_ed_geocoded <-
  crisis_ed_address %>%
  mutate_geocode(
    location = full_address, 
    source = "google",
    output = "more", 
    messaging = T,
    override_limit = T
  )

factpal <- colorFactor("viridis", unique(crisis_ed_geocoded$type))
factpal <- colorFactor(
  c("#823574","#f32d4c","#8f8cff","#ff8122","#eda1a3"),
  #c("#208eb7", "#bd395c", "#12d388", "#ff0087", "#6fcf1d"),
  #c("#332288", "#88CCEE", "#117733", "#DDCC77", "#CC6677"), 
  unique(crisis_ed_geocoded$type)
)

crisis_ed_radius <-  
  crisis_ed_geocoded %>%
  filter(is.na(lon) == F) %>%
  leaflet() %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  setView(
    lng = -84.506836, 
    lat = 44.182205, 
    zoom = 7
  ) %>%
  addCircles(
    lng = ~lon, lat = ~lat,
    color = ~factpal(as.factor(type)), 
    stroke = FALSE,
    radius = 30 * 1609.34, # Add radius in meters (converted from miles)
    fillOpacity = 0.02
  ) %>%
  addCircleMarkers(
    lng = ~lon, 
    lat = ~lat,
    color = ~factpal(as.factor(type)),
    popup = ~paste0(
      "<b>Name:</b> ",htmlEscape(facility),"<br/>",
      "<b>Address:</b> ",htmlEscape(full_address),"<br/>",
      "<b>Program Type:</b> ",htmlEscape(type)
    ),
    stroke = FALSE, 
    radius = 4,
    fillOpacity = 0.6
  ) %>%
  leaflet::addLegend(
    title = "Program Types",
    pal = factpal,
    values = ~type
  )

# Save map and geocoded data
htmlwidgets::saveWidget(crisis_ed_radius, file = "crisis_ed_radius.html")
feather::write_feather(crisis_ed_geocoded, "data/crisis_ed_radius.feather")



