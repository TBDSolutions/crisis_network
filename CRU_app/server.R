## server.R ##

shinyServer(
  function(input, output) { 
    CRU_reactive <- reactive({
      CRU_address %>% mutate(
        Radius = ifelse(Urban_Rural == "Urban", input$radius_len_urban * 1609.34, input$radius_len_rural * 1609.34)
      )
    })
    
    output$CRU_radius <- renderLeaflet({
      CRU_leaf <- CRU_reactive() %>%
        filter(!is.na(lon)) %>%
        filter(Adult_Youth %in% input$age_group) %>%
        leaflet() %>%
        addTiles() %>%
        addProviderTiles(providers$Stamen.Toner) %>%
        setView(
          lng = -85,
          lat = 44,
          zoom = 6
        )
      
    if(input$radius_check == T){
      # first draw a radius for urban areas
      CRU_leaf %>%
        addCircles(
          lng = ~lon,
          lat = ~lat,
          color = ~factpal(Urban_Rural),
          stroke = FALSE,
          # Add radius in meters (= 60 miles)
          radius = ~Radius,
          fillOpacity = input$radius_opacity
        ) %>%
        addCircleMarkers(
          lng = ~lon,
          lat = ~lat,
          color = ~factpal(Urban_Rural),
          popup = ~paste0(
            "<b>Name:</b> ",htmlEscape(Name),"<br/>",
            "<b>Address:</b> ",htmlEscape(Location),"<br/>",
            "<b>Operated by:</b> ",htmlEscape(Operated_by),"<br/>",
            "<b>Age Group:</b> ",htmlEscape(Adult_Youth),"<br/>",
            "<b>Area:</b> ",htmlEscape(Urban_Rural)
          ),
          stroke = FALSE,
          radius = 4,
          fillOpacity = 0.8
        )

      } else{
        CRU_leaf %>%
          addCircleMarkers(
            lng = ~lon,
            lat = ~lat,
            color = ~factpal(Urban_Rural),
            popup = ~paste0(
              "<b>Name:</b> ",htmlEscape(Name),"<br/>",
              "<b>Address:</b> ",htmlEscape(Location),"<br/>",
              "<b>Operated by:</b> ",htmlEscape(Operated_by),"<br/>",
              "<b>Age Group:</b> ",htmlEscape(Adult_Youth),"<br/>",
              "<b>Area:</b> ",htmlEscape(Urban_Rural)
            ),
            stroke = FALSE,
            radius = 4,
            fillOpacity = 0.8
          )
      }
     })
  })
