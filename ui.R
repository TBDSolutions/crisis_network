## ui.R ##

header <- dashboardHeader(
  title = "Crisis Map"
)

body <- dashboardBody(
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
        leafletOutput("crisis_radius", height = 800)
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
            "radius_len",
            "Lengh of the Radius: (miles)",
            min = 10, max = 100, value = 50
          )
        ),
        selectInput(
          "program_type", "Choose type(s) of program",
          unique(crisis_address$type),
          selected = unique(crisis_address$type),
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
