## server.R ##

shinyServer(
  function(input, output) { 
    
    output$crisis_radius <- renderLeaflet({
      crisis_leaf <- crisis_address %>%
        filter(is.na(lon) == F) %>%
        filter(type %in% input$program_type) %>%
        leaflet() %>%
        addProviderTiles(providers$Stamen.Toner) %>%
        setView(
          lng = -95,
          lat = 37,
          zoom = 4
        )
      
      # make a pallete
      # crisis_address$type_cat <- factor(sample.int(4L, nrow(crisis_address), TRUE))
      # factpal <- colorFactor(topo.colors(4), crisis_address$type_cat)
      
      if(input$radius_check == T){
        crisis_leaf %>%
          addCircles(
            lng = ~lon,
            lat = ~lat,
            color = "#FF9F55",
            stroke = FALSE,
            # Add radius in meters (= 60 miles)
            radius = input$radius_len * 1609.34,
            fillOpacity = 0.2
          ) %>%
          addCircleMarkers(
            lng = ~lon,
            lat = ~lat,
            color = ~factpal(type),
            popup = ~paste0(
              "<b>Name:</b> ",htmlEscape(Name),"<br/>",
              "<b>Address:</b> ",htmlEscape(Location),"<br/>",
              "<b>Operated by:</b> ",htmlEscape(Operated),"<br/>",
              "<b>Program Type:</b> ",htmlEscape(type)
            ),
            stroke = FALSE,
            radius = 4,
            fillOpacity = 0.6
          ) %>%
          addLegend(
            title = "Program Types",
            pal = factpal,
            values = ~type
          )
      } else{
        crisis_leaf %>%
          addCircleMarkers(
            lng = ~lon,
            lat = ~lat,
            color = ~factpal(type),
            popup = ~paste0(
              "<b>Name:</b> ",htmlEscape(Name),"<br/>",
              "<b>Address:</b> ",htmlEscape(Location),"<br/>",
              "<b>Operated by:</b> ",htmlEscape(Operated),"<br/>",
              "<b>Program Type:</b> ",htmlEscape(type)
            ),
            stroke = FALSE,
            radius = 4,
            fillOpacity = 0.6
          ) %>%
          addLegend(
            title = "Program Types",
            pal = factpal,
            values = ~type
          )
      }
    })
  })