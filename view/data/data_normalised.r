data_normalised_page=fluidRow(
  box(width = 12,
      background = "aqua",
      fluidRow(
        column(width = 3,
               h2("Data normalised"), ),
        column(
          width = 3,
          selectInput(
            inputId = "extportNorDataFormat",
            label = "Choose your format",
            choices = c(
              "CSV" = "csv",
              "Excel" = "xlsx",
              "RDS Object" = "rds",
              "R Object" = "robject"
            )
          )
        ),
        column(
          width = 3,
          textInputAddon(
            inputId = "fileNameOfNorExport",
            label = "Enter the export name:",
            placeholder = "Enter the export name",
            value = "data_normalised",
            addon = icon("name")
          )
        ),
        column(
          width = 3,
          br(),
          downloadBttn(
            outputId ="exportNorData",
            label = "Normalised data",
            style = "jelly",
          )
        )
      )),
  box(
    width = 12,
    title = h4("Normalised"),
    status = "primary",
    div(
      style="height:500px; overflow:auto",tableOutput("dataNormalisedOutput"))
  )
)
