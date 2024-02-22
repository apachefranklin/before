library(shiny)
library(shinydashboard)


item_set_page = div(
  pattern_header_page,
  fluidRow(
    
    box(
      width = 6,
      status ="primary",
      solidHeader = TRUE,
      title = h2("Pattern extracted"),
      div(
        verbatimTextOutput("patternFrequentsItemsView"),
        style="width:100%;height:500px; overflow:auto; background-color:white;"
        
      )
    ),
    box(
      width = 6,
      status ="primary",
      solidHeader = TRUE,
      title = h2("Rules extracted"),
      div(
        verbatimTextOutput("patternRulesView"),
        style="width:100%;height:500px; overflow:auto; background-color:white;"
      )
    ),
    
    #le box du plot des regles
    box(
      width=6,
      title = "Plot of frequents itemsets",
      plotOutput("plotFrequentsView")
    ),
    box(
      width=6,
      title = "Plot of rules",
      plotOutput("plotRulesView")
    ),
  )
  ,    style='background-color:#f0f0f0;'

  )