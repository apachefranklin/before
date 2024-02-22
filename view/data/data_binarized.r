data_binarized_page=fluidRow(
  box(width = 12,
      background = "aqua",
      fluidRow(
        column(width = 3,
               h2("Data binarised"), ),
        column(
          width = 3,
          selectInput(
            inputId = "extportBinDataFormat",
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
            inputId = "fileNameOfBinExport",
            label = "Enter the export name:",
            placeholder = "Enter the export name",
            value = "data_binarised",
            addon = icon("name")
          )
        ),
        column(
          width = 3,
          br(),
          downloadBttn(
            outputId ="exportBinData",
            label = "Binarised data",
            style = "jelly",
          )
        )
      )),
  box(
    width = 12,
    title = h4("Data binarized"),
    status = "primary",
    div(
      style="height:500px; overflow:auto",tableOutput("dataBinarizedOutput"))
  )
)
