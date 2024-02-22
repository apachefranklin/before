header_load_data_page = fluidRow(box(
  width = 12,
  h3("Load data for classification"),
  fluidRow(
    column(
      width = 2,
      fileInput(inputId = "dataForClassification", label = "Choose your data")
    ),
    column(
      width =1,
      textInput(
        inputId = "naValueIs",
        label = "Na value is:",
        placeholder = "exemple:? or by default is it nothing"
      )
    ),
    column(
      width = 2,
      selectInput(
        inputId = "applyToNa",
        choices = c(
          "Delete" = 1,
          "Replace by a modal value" = 2,
          "Replace by a mean" = 3
        ),
        label = "Apply to na:"
      )
    ),
    column(
      width =1,
      checkboxInput(
        inputId = "headerPresent",
        label = tags$b("Header?"),
        value = FALSE
      ),
      checkboxInput(
        inputId = "rowPresent",
        label = tags$b("rows?"),
        value = FALSE
      )
    ),
    column(
      width = 1,
      textInput(
        inputId = "columnToBinarize",
        label = "List of factor column",
        placeholder = "Exemple: 1,3,5,6"
      ),
      helpText("It is the list of column who don't have a continuous value")
    ),
    column(
      width=2,
      numericInput(
        inputId = "targetAttribute",
        label = "Number of class attribute:",
        min = 0,
        value = 1
        
      ),
      helpText("if zero, you dataset don't have target attribut")
    ),
    column(
      width = 2,
      br(),
      actionButton(
        inputId = "btnMakeClassification",
        label = "Make classification",
        style = 'background-color:#69f0ae; color:white; font-weight:bold'
      )
    )
    
  ),
  br()
),
  box(
    width = 12,
    title = h4("Data loaded"),
    status = "primary",
    solidHeader = T,
    div( style = 'background-color:white; padding:14px !important,width:100px !important; height:600px;overflow:auto;', tableOutput("dataLoad"))
  )
)
