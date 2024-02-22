decision_tree_page = div(fluidRow(
  column(width = 8,
         fluidRow(
           box(
             width = 12,
             title = "Decision tree of the data",
             status = "primary",
             plotOutput("decisionTreePlot", height = '800px')
           )
         )),
  column(width = 4,
         fluidRow(
           box(
             status = "danger",
             width = 12,
             title = "Confusion matrix with tree",
             tableOutput("confusionMatrixTree")
           ),
           box(
             status = "success",
             width = 12,
             title = "Mesure of the model",
              strong(textOutput("percentSuccessTree"))
           )
         ),
         box(
           width = 12,
           h3("Mesure about the model make by tree of decision"),
           uiOutput("decisionTreeStatitic")
         )),
 
))
