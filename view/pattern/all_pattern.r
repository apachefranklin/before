
all_pattern_page=fluidRow(
  box(
    width = 12,
    background = "aqua",
    h2("Dataset for Pattern and rules extractions")
  )
  ,
  box(
    width = 12,
    div(
      tableOutput("patternDataSet"),
      style="width:100%;height:600px; overflow:auto; background-color:white"
    )
    
  )
)
   