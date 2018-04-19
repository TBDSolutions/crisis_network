## server.R ##

fact_rad <- function(x){
  if(x == "Urban") 1
  if(x == "Rural") 0
}

shinyServer(
  function(input, output) { 
    
    output$CRU_radius <- renderLeaflet({
      CRU_leaf <- CRU_address %>%
        filter(!is.na(lon)) %>%
        filter(Adult_Youth %in% input$age_group) %>%
        leaflet() %>%
        addProviderTiles(providers$Stamen.Toner) %>%
        setView(
          lng = -85,
          lat = 44,
          zoom = 7
        )
      
    if(input$radius_check == T){
      # first draw a radius for urban areas
      CRU_leaf %>%
        addCircles(
          lng = ~lon,
          lat = ~lat,
          color = ~factpal(Adult_Youth),
          stroke = FALSE,
          # Add radius in meters (= 60 miles)
          radius = ~fact_rad(Urban_Rural) * 20 * 1609.34,
          fillOpacity = 0.2
        ) %>%
        addCircleMarkers(
          lng = ~lon,
          lat = ~lat,
          color = ~factpal(Adult_Youth),
          popup = ~paste0(
            "<b>Name:</b> ",htmlEscape(Name),"<br/>",
            "<b>Address:</b> ",htmlEscape(Location),"<br/>",
            "<b>Operated by:</b> ",htmlEscape(Operated_by),"<br/>",
            "<b>Age Group:</b> ",htmlEscape(Adult_Youth),"<br/>",
            "<b>Area:</b> ",htmlEscape(Urban_Rural)
          ),
          stroke = FALSE,
          radius = 4,
          fillOpacity = 0.6
        )

      } else{
        CRU_leaf %>%
          addCircleMarkers(
            lng = ~lon,
            lat = ~lat,
            color = ~factpal(Adult_Youth),
            popup = ~paste0(
              "<b>Name:</b> ",htmlEscape(Name),"<br/>",
              "<b>Address:</b> ",htmlEscape(Location),"<br/>",
              "<b>Operated by:</b> ",htmlEscape(Operated_by),"<br/>",
              "<b>Age Group:</b> ",htmlEscape(Adult_Youth),"<br/>",
              "<b>Area:</b> ",htmlEscape(Urban_Rural)
            ),
            stroke = FALSE,
            radius = 4,
            fillOpacity = 0.6
          )
      }
     })
  })