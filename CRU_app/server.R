## server.R ##

shinyServer(
  function(input, output) { 
    # CRU_reactive <- reactive({
    #   CRU_address %>% mutate(
    #     Radius = ifelse(Urban_Rural == "Urban", input$radius_len_urban * 1609.34, input$radius_len_rural * 1609.34)
    #   )
    # })
    
    ## GREY MAP TILES ##
    # "Esri.WorldGrayCanvas" 
    # "HERE.normalDayGreyMobile" 
    # "OpenMapSurfer.Grayscale"
    # "CartoDB.DarkMatter"
    # "Stamen.TonerLite"
    # "Stamen.TonerBackground"  
    # "OpenStreetMap.BlackAndWhite"
    
    output$CRU_radius <- renderLeaflet({
      CRU_leaf <- CRU_address %>%
        filter(!is.na(lon)) %>%
        filter(Adult_Youth %in% input$age_group) %>%
        leaflet() %>%
        addProviderTiles("Esri.WorldGrayCanvas") %>%
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
          color = ~factpal(Urban_Rural),
          stroke = TRUE,
          # Add radius in meters (= 60 miles)
          radius = ~ifelse(Urban_Rural == "Urban", input$radius_len_urban * 1609.34, input$radius_len_rural * 1609.34),
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
          fillOpacity = 0.9
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
