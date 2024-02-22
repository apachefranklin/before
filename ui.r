
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(factoextra)

library(rpart)
library(neuralnet)
library(cluster)
library(biclust)
library(arules)

#chargment des vus
source("view/side_menu.r")
source("view/classification/header_load_data.r")
source("view/classification/decision_tree.r")
source("view/classification/neural_net.r")
source("view/classification/kmean_page.r")
source("view/classification/dendogramm_page.r")
source("view/classification/kohonen.r")
source("view/classification/biclust.r")

source("view/pattern/pattern_header.r")
source("view/pattern/item_set.r")
source("view/pattern/rule.r")
source("view/pattern/all_pattern.r")

source("view/data/data_without_na.r")
source("view/data/data_normalised.r")
source("view/data/data_binarized.r")
shinyUI(
  dashboardPage(
    dashboardHeader(title = "BEFORE"),
    dashboardSidebar(side_menu),
    dashboardBody(
      tabItems(
        tabItem(tabName = "loadDataView",header_load_data_page), 
        tabItem(tabName = "decisionTreeView",decision_tree_page),
        tabItem(tabName = "neuralNetWork",neural_page),
        tabItem(tabName = "kmean",kmean_page),
        tabItem(tabName = "dendogramm",dendogramm_page),
        tabItem(tabName = "kohonen",kohonen_page),
        tabItem(tabName = "biclust",biclust_page),
        tabItem(tabName = "AllFrequents",item_set_page),
        tabItem(tabName = "allRules",rules_page),
        tabItem(tabName = "allPattern",all_pattern_page),
        tabItem(tabName = "dataWithoutNa",without_na_page),
        tabItem(tabName = "normalisedData",data_normalised_page),
        tabItem(tabName = "BinarisedData",data_binarized_page)
      )
     ),
    title = "Ada",
    skin = "red"
   )
    
  )