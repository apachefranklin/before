

pattern_header_page=div(
  fluidRow(
    box(background = "teal",
        status = "primary",
      width = 12,
      h2("Enter the confiance and the mininal support for extraction of rules and items"),
      fluidRow(
        column(
          width = 6,
          numericInput("supportMin","Enter the support",min=1,value = 1)
        ),
        column(
          width = 6,
          numericInput("confianceMin","Enter the min confiance",min=1,value=1)
        )
      )
    )
  )
)