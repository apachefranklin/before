neural_page = div(br(),
                  h2("Welcome to neural classification: We continous to use data you load previoulis"),
                  fluidRow(
                    column(
                      width = 8,
                      fluidRow(
                        box(title = "",
                            width = 12,
                            numericInput("nnHiddenLayers", "Number of hidden layer", 1),
                            hr(),
                            strong("List of column predict by neural net:"),
                            verbatimTextOutput("columnPredictBynnO"),
                            solidHeader = TRUE,
                            status = "primary"
                        ),
                        #ici sortira le plot de la couche de neurone
                        box(
                          title = "Plot of your neural network",
                          width = 12,
                          plotOutput("nnPlotView")
                        )
                      )
                    ),
                    column(
                      width = 4,
                      fluidRow(
                        box(
                          width=12,
                          title="Confusion matrix of neural network",
                          tableOutput("nnConfusionMatrix")
                        ),
                        box(
                          width=12,
                          title = "Neural network mesure for your data",
                          uiOutput("nnMesure")
                        ),
                        
                        uiOutput("nnStatistic")
                      )
                      )
                    )
                    ,
                  div(
                    h3("Binarised data"),
                    tableOutput("dataBinarized"),
                    style='background-color:white;border-top:8px solid blue; width:100%; height:400px;overflow:auto;'
                  ))
