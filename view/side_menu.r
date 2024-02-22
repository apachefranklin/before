

side_menu = sidebarMenu(
  menuItem(
    text = "Data",
    menuSubItem(
      text = "Load data",
      tabName = "loadDataView"
    )
    ,
    
    menuSubItem(text = "Data without Na",
                tabName = "dataWithoutNa"),
    menuSubItem(text = "Data Binarised",
                tabName = "BinarisedData"),
    menuSubItem(text = "Normalised Data",
                tabName = "normalisedData")
  ),
  menuItem(
    "Extraction des motifs",
    menuSubItem(text = "View Data",
                tabName = "allPattern"),
    
    menuSubItem("Extraction",
                tabName = "AllFrequents")
  ),
  #maintenan on gere le tp deux
  menuItem(
    "Classification",
    menuSubItem(text = "Decision tree",
                tabName = "decisionTreeView"),
    menuSubItem("Neural network",
                tabName = "neuralNetWork"),
    menuSubItem("K-means",
                tabName = "kmean"),
    menuSubItem("Dendogramm",
                tabName = 'dendogramm')
  ),
  menuItem(
    "Biclustering",
    menuSubItem("With kohonen", tabName = "kohonen"),
    menuSubItem("With Biclust", tabName = "biclust")
  ),
  menuItem("About",
           tabName = "about"),
  id = "leftMenu"
)