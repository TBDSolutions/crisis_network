## ui.R ##

header <- dashboardHeader(
  title = "CRU Map"
)

body <- dashboardBody(
  tags$head(tags$style(HTML('
        .skin-black .main-header .logo {
          background-color: #ffffff; color:#000000;
          
        }',
        '.skin-black .main-header .logo:hover {
          background-color: #000000; color:#ffffff;
        }
      '))),
  # Suppress errors from waiting on reactive dataframes to be built.
  tags$style(
    type = "text/css",
    ".shiny-output-error { visibility: hidden; }",
    ".shiny-output-error:before { visibility: hidden; }"
    
  ),
  fluidRow(
    column(
      width = 9,
      box(
        width = NULL, solidHeader = TRUE,
        leafletOutput("CRU_radius", height = 500)
      )
    ),
    column(
      width = 3,
      box(
        width = NULL,
        checkboxInput("radius_check", "Display Radius:", value = T),
        conditionalPanel(
          condition = "input.radius_check == true",
          sliderInput(
            "radius_len_urban",
            "Lengh of the Radius for Urban: (miles)",
            min = 10, max = 200, value = 60
          ),
          sliderInput(
            "radius_len_rural",
            "Lengh of the Radius for Rural: (miles)",
            min = 10, max = 200, value = 120
          ),
          sliderInput(
            "radius_opacity",
            "Opacity of the Radius",
            min = 0.1, max = 0.5, value = 0.15
          )
        ),
        selectInput(
          "age_group", "Choose the age group",
          c(
            "Adult" = "Adult",
            "Youth" = "Youth"
          ),
          selected = c("Adult","Youth"),
          multiple = TRUE, selectize = TRUE, width = NULL, size = NULL
        )
      )
    )
  )
)

dashboardPage(
  skin = "black",
  header,
  dashboardSidebar(disable = TRUE),
  body
)
