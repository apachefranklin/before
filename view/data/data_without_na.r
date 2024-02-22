without_na_page = fluidRow(
  box(
    width = 12,
    background = "aqua",
    fluidRow(
      column(width = 3,
             h2("Data wihout na value"), ),
      column(
        width = 3,
        selectInput(
          inputId = "extportNaDataFormat",
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
          inputId = "fileNameOfNaExport",
          label = "Enter the export name:",
          placeholder = "Enter the export name",
          value = "data_without_na",
          addon = icon("name")
        )
      ),
      column(
        width = 3,
        br(),
        downloadBttn(
          outputId ="exportNaData",
          label = "Export data without na",
          style = "jelly",
        )
      )
    )
  ),
  box(
    width = 12,
    title = h4("Data without na"),
    status = "primary",
    div(style = "height:500px; overflow:auto", tableOutput("dataWithoutNaOutput"))
  )
)
