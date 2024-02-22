dendogramm_page=div(
  fluidRow(
    box(
      width = 12,
      background = 'aqua',
      h1("Plot of dendogramm")
    ),
    
    box(width = 12,
        plotOutput("mainDendogrammView"))
  )
  )