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
        leafletOutput("crisis_radius", height = 500)
      )
    ),
    column(
      width = 3,
      box(
        width = NULL,
        sliderInput(
          "radius_len",
          "Lengh of the Radius:",
          min = 50000, max = 150000, value = 96560.6
        )
      )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)