kmean_page=div(
  h5("Welcome to a kamean page"),
  fluidRow(
    box(
      status = "warning",
      width = 12,
      numericInput("kGroupNumber","Enter the number of group:",min=2, value = 2),
      solidHeader = TRUE
    ),
    box(
      status = "success",
      textOutput("numberGroup"),
      h3("Plot :"),
      plotOutput("kMainPlotView")
    
    ),
    box(("Plot b to b"),plotOutput("kMainPlotView2")),
    box(("Plot b to b"),plotOutput("kMainPlotView3"))
  )
)