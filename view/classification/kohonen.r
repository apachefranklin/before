kohonen_page=fluidRow(
  box(
    width = 12,
    background = "teal",
    h1("Kohonen data and plot use also the data you load prevoulys")
  ),
  box(
    width = 12,
    title = "Summary of data after we apply som function to normalised data",
    verbatimTextOutput("summaryDataWithKohonenO")
  ),
  box(
    #Il met ici la distance moyenne entre les differents
    #cluster a chaque iteration au cours de son evolution duran
    #L'entrainement
    background = "light-blue",
    title = "Khonnen Trainning progress graph", 
    plotOutput("kohoTrainProgressPlot")
  ),
  box(
    title = "Kohonen Cluster visualisation",
    plotOutput("kohoClusterPlot")
  )
)