library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(factoextra)

library(xlsx)

library(rpart)
library(neuralnet)
library(cluster)
library(biclust)
library(arules)
library(arulesViz)
library(colorspace)
library(kohonen)

source("librairies/classification_global_function.r")
source("librairies/classification_pretraitement_function.r")
source("librairies/auto_binarize.r")
source("librairies/pattern_global_function2.r")
source("librairies/pattern_itemset_rules_function.r")

##lecture du fichier de donnees
#fonction qui charge les donness d'undata frame

##declaration des variables globales donc on aura besoin pour les

target_attribute = data.frame()

shinyServer(function(input, output, session) {
  get_load_data = reactive({
    #cette fonction renvoies les donnees charger par notre application
    data_file = input$dataForClassification
    if (is.null(input$dataForClassification)) {
      return ()
    }
    return(
      read.table(
        file = input$dataForClassification$datapath,
        sep = ",",
        na.strings = input$naValueIs,
        header = input$headerPresent
      )
    )
  })#fin de la fonction qui charge les donnees
  
  
  #fonction qui recupere le nom du target data
  targetName = reactive({
    header_names = colnames(get_load_data())
    targetName = header_names[input$targetAttribute]
    return (targetName)
  }) #fin de lafonction qui recupere le targetname
  
  
  
  ##cette fonction applle une fonction de traitement des
  ##na value en fonction des choix de l'utilisateur
  get_data_na_remove = reactive({
    if (input$applyToNa == '1') {
      #on appel l'algoritme de suppresiion
      return (delete_na_value(get_load_data()))
    }
    else if (input$applyToNa == '2') {
      return (replace_by_modal_value(get_load_data()))
    }
    else{
      return (f_mode_moyenne(get_load_data()))
    }
  })#fin de la fonction qui gere les na values
  
  #fonction reactive pour recuperer le jeu de donnees d'entrainement
  trainAndTestSet = reactive({
    Get_train_test_set(get_data_na_remove(), trainpercent = 66.66)
  }) #fin de la fonction qui gere le chargement des donne d'entrainement
  
  
  ##cette fonction fait tout ce qui y'a a faire sur les donnnes
  ##a utilises dans les arbres de decision
  decision_tree = reactive({
    if (!is.null(get_load_data())) {
      retour = list()
      header_names = colnames(get_load_data())
      all_data = trainAndTestSet()
      formule = as.formula(paste(targetName(), "~."))
      tree_data_train = rpart(formula = formule, data = all_data$trainSet)
      predict_with_tree = predict(tree_data_train, all_data$testSet[, -input$targetAttribute], type =
                             c("class"))
      confusion_matrix = table(predict_with_tree, all_data$testSet[, input$targetAttribute])
      
      retour$testSet = all_data$testSet
      retour$trainSet = all_data$trainSet
      retour$tree = tree_data_train
      retour$confusion_matrix = confusion_matrix
      retour$predict = predict_with_tree
      return (retour)
    }
  })
  
  ##fonction qui prends les matrice de confution
  ##en parametre et retourne les differents statistiques
  confusion_stat_tree = reactive({
    summary_confusion(decision_tree()$confusion_matrix)
  })
  ##code pour la binarisation
  binarize_data=reactive(
    auto_binarize(get_data_na_remove(),input$targetAttribute)
  ) #fin de la binnarisation
  normalize_data=reactive({
    all_data=binarize_data()
    return (scale(all_data$data,center = T,scale = T))
  }
    
  )
  
  ##ici les fonctions reactive pour les kmenas
  k_means=reactive({
    all_data=binarize_data()
   return (kmeans(normalize_data(),input$kGroupNumber))
  }
  )
    ##pour le plot principal de kmeans
  output$kMainPlotView=renderPlot({
    all_data=binarize_data()
    k_mean=kmeans(scale(all_data$data,center = T,scale = T),centers =input$kGroupNumber,nstart = input$kGroupNumber+1)
    #clusplot(scale(bin_auto$data,center = T,scale = T),col=k_mean$cluster)
    to_remove=get_indice_from_vect(colnames(all_data$data),all_data$col_prediction)
    fviz_cluster(k_mean,all_data$data[,-to_remove],geom='points')
   #clusplot(all_data$all[,-input$targetAttribute],k_mean$cluster,color = k_mean$cluster)
    # data=iris[,-5]
    # a=kmeans(data,3)
    # clusplot(data,a$cluster)
  }
  )
  
  output$kMainPlotView2=renderPlot({
    all_data=binarize_data()
    k_mean=kmeans(scale(all_data$data,center = T,scale = T),centers =input$kGroupNumber,nstart = input$kGroupNumber+1)
    to_remove=get_indice_from_vect(colnames(all_data$data),all_data$col_prediction)
    clusplot(get_data_na_remove()[,-input$targetAttribute],k_mean$cluster,color = k_mean$cluster)
  }
  )
  
  output$kMainPlotView3=renderPlot({
    all_data=binarize_data()
    k_mean=kmeans(scale(all_data$data,center = T,scale = T),centers =input$kGroupNumber,nstart = input$kGroupNumber+1)
    to_remove=get_indice_from_vect(colnames(all_data$data),all_data$col_prediction)
    plot(get_data_na_remove()[,-input$targetAttribute],k_mean$cluster,col=k_mean$cluster)
  }
  )
  
  output$mainDendogrammView=renderPlot({
    data_t=normalize_data()
    all_data=binarize_data()
    to_remove=get_indice_from_vect(colnames(all_data$data),all_data$col_prediction)
    data_t=data_t[,-to_remove]
    hac=agnes(data_t)
    pltree(hac)
  },height =800)
  
  
  output$numberGroup=renderText(input$kGroupNumber)
    
  
  ##Fonction reactive pour les motif frequents
  ##on definit d'abord le jeu de donnees
  patternTransaction = reactive({
    loadPretraitedData()
  })
  ##fin de la definition du jeu de donnnes
  
  #on fait la fonction recative des item frequents
  getPatternFrequents=reactive({
    ght=getRuleOrItems(
      dataset=patternTransaction(),
      support = input$supportMin,
      confiance = input$confianceMin
    )
    return(ght)
  })
  #maintenant on fait la fonction pour les regles
  getPatternRules=reactive({
    ght=getRuleOrItems(
      dataset=patternTransaction(),
      support = input$supportMin,
      confiance = input$confianceMin,
      eTarget="rules")
    return(ght)
  })
  
  output$patternDataSet = renderTable({
    pattern_load_data()
  })
  
  
  output$patternFrequentsItemsView=renderPrint({
    ght=getPatternFrequents()
    str(inspect(ght))
  })
  ##find de la definiton de la sortie des motfis frequents

  output$patternRulesView=renderPrint(
    str(inspect(getPatternRules()))
  )
output$paramConfMinView=renderText(input$supportMin)
output$paramSuppMinView=renderText(input$confianceMin)
  # output$summaryRules=renderPrint(
  #     getPatternRules()
  # )
  # 
    ##Code pour le plot des items et autres
output$plotFrequentsView=renderPlot(
  plot(getPatternFrequents(),control=list(col=sequential_hcl(100)))
)
output$plotRulesView=renderPlot(
  plot(getPatternRules(),control=list(main="Plot of generated rules ",col=rainbow(5)))
)
  
  
  
##ici nous allons faire des reactive fait pour les
  ##reseaude neuronnes

  #obtention des donnees d'entraiments pour les reseaux de neuronnes
  trainAndTestSetForNeural=reactive(
    Get_train_test_set(binarize_data()$data,trainpercent=66.6)
  )
  
  neural_net=reactive({
    #recuperation des noms de colonnes a utlise pour l'entrainement
    col_name_for_prediction=binarize_data()$col_prediction
    all_data=trainAndTestSetForNeural()
    retour=list()
    #maintenan nous devons former la formule pour l'entraiment
    predict_form_side=paste(col_name_for_prediction,collapse = '+')
    train_formula=as.formula(paste(predict_form_side,"~.",sep = ""))
    #maintenant nous devons recuperer les indices des colonnes a supprimer
    col_to_remove=get_indice_from_vect(colnames(all_data$testSet),col_name_for_prediction)
    #print(train_formula)
    # print(col_name_for_prediction)
    # print(predict_form_side)
    neural_train =neuralnet(formula = train_formula,data=all_data$trainSet,hidden =c(input$nnHiddenLayers))
    
    predictionNeuralNet=neuralnet::compute(neural_train,all_data$testSet[,-col_to_remove])$net.result

    maxidx <- function(arr) { return(which(arr == max(arr))) }
    idx <- apply(predictionNeuralNet, c(1), maxidx)
    prediction <- col_name_for_prediction[idx]
    #confusion_matrix=table(prediction, get_data_na_remove()[,input$targetAttribute])
    #confusion_matrix = table(prediction, all_data$testSet[, input$targetAttribute])

    retour$testSet = all_data$testSet
    retour$trainSet = all_data$trainSet
    retour$neural_net =neural_train
    #retour$confusion_matrix = confusion_matrix
    retour$predict =prediction
    return (retour)
  })
  
  ##debut des render fonction
  ##render for neural
  output$dataBinarized=renderTable(
    binarize_data()$data
  )
  output$columnPredictBynnO=renderPrint(
    binarize_data()$col_prediction
  )
  output$nnPlotView=renderPlot(plot(neural_net()$neural_net,rep="best"))
  
  ##cette fonction permet d'afficher les donnes du tableau
  ##charger dans la vue
  output$dataLoad = renderTable({
    get_load_data()
  } ,
  striped = TRUE,
  bordered = TRUE,
  hover = TRUE,
  width = 50,
  spacing = 'xs') ##sortie de la table original de donnees
  
  #sortie de la matrice de confusion de l'arbre
  output$confusionMatrixTree = renderTable(decision_tree()$confusion_matrix)
  ##fonction pour ploter l'arbre de decision
  output$decisionTreePlot = renderPlot({
    if (!is.null(get_load_data())) {
      plot_decision_tree(decision_tree()$tree, treename = "du jeux de donnes")
    }
  })
  
  ##le output pout les pourcentages sur le model
  output$percentSuccessTree = renderText({
    nombre_bien_predit = confusion_stat_tree()$good_prediction
    nombre_total = confusion_stat_tree()$all_prediction
    percent_good = as.integer((nombre_bien_predit / nombre_total) * 100) ##pourcentage de reusiite
    #progressBar(status = 'success',id = "treePercentSuccessP",display_pct = TRUE,value = percent_good,striped = TRUE,size = 'xxs')
  paste("percent of good prediction: ",as.character(percent_good),"%",sep = "")
    
      })
  ##Fonction pour avoir les infobox
  ##automaqtique representant les staititistiques
  output$decisionTreeStatitic = renderUI({
    ##recuperons lenombres d'element different
    col_names = colnames(decision_tree()$confusion_matrix)
    nb = length(col_names)
    #on aura autemps de nb rappel que de nb precision
    rappel_output_list = lapply(1:nb, function(i) {
      info_box_name = paste("RappelTree", i, sep = "")
      infoBoxOutput(info_box_name, width = 12)
    })
    
    precision_output_list = lapply(1:nb, function(i) {
      info_box_name = paste("PrecisionTree", i, sep = "")
      infoBoxOutput(info_box_name, width = 12)
    })
    do.call(tagList, precision_output_list)
    do.call(tagList, rappel_output_list)
  })
  
  
  
  
  
  ##Les renders lie aux datas
  output$dataWithoutNaOutput=renderTable(get_data_na_remove())
  output$dataNormalisedOutput=renderTable(normalize_data())
  output$dataBinarizedOutput=renderTable(binarize_data()$data)
  
  ##Maintenant on gere les exportantions lies aux data
  output$exportNaData=downloadHandler(
    filename =function(){
      file_name(input$fileNameOfNaExport,input$extportNaDataFormat) 
    },
    content = function(file){
      export_file_data(input$extportNaDataFormat,get_data_na_remove(),file)
    }
  )
  ##Export des donness binarise
  output$exportBinData=downloadHandler(
    filename =function(){
      file_name(input$fileNameOfBinExport,input$extportBinDataFormat)
    },
    content = function(file){
      export_file_data(input$extportBinDataFormat,binarize_data()$data,file)
    }
  )
  
  ##Export des donness normalise
  output$exportNorData=downloadHandler(
    filename =function(){
      file_name(input$fileNameOfNorExport,input$extportNorDataFormat)
    },
    content = function(file){
      export_file_data(input$extportNorDataFormat,normalize_data(),file)
    }
  )
  ##Les renders  liee au kohonnen
  output$summaryDataWithKohonenO=renderPrint({
    som_data<- som(normalize_data(), grid = somgrid(5, 5, "rectangular"))
    summary(som_data) 
  })
  
  output$kohoTrainProgressPlot=renderPlot({
    som_model <- som(normalize_data(), grid=somgrid(5, 5, "rectangular"), alpha=c(0.5,0.1), keep.data = TRUE)
    plot(som_model, type="changes")
    #plot(som_model, type="dist.neighbours", main = "SOM neighbour distances")
    #plot(som_model, type="codes")
    #plot(som_model, type = "property", property = getCodes(som_model)[,1], main=colnames(getCodes(som_model))[1])
  })
  
  output$kohoClusterPlot=renderPlot({
    som_model <- som(normalize_data(), grid=somgrid(5, 5, "rectangular"), alpha=c(0.5,0.1), keep.data = TRUE)
    som_cluster <- as.double(cutree(hclust(dist(som_model$codes)), 6))
    plot(som_model, type="mapping", bgcol = pretty_palette[som_cluster], main = "Clusters") 
    add.cluster.boundaries(som_model, som_cluster)
  })
  
  
  # ##maintenant nous faisons la boucle pour faire les differents renders
  for (i in 1:10) {
    local({
      my_i = i
      info_box_precision_name = paste("PrecisionTree", my_i, sep = "")
      info_box_rappel_name = paste("RappelTree", my_i, sep = "")
      
      
      ##sortie de la premiere infobox pour une precision
      output[[info_box_precision_name]] = renderInfoBox({
        col_names = colnames(decision_tree()$confusion_matrix)
        nom = col_names[my_i]
        infoBox(paste("Precisiosn pour les", nom),
                confusion_stat_tree()$precision[nom])
      })
      
      #sortie de la premiere infobox pour un rappel
      output[[info_box_rappel_name]] = renderInfoBox({
        col_names = colnames(decision_tree()$confusion_matrix)
        nom = col_names[my_i]
        infoBox(
          title = paste("Les mesures de la classe", nom),
          value = div(
            strong("Rappel="),
            confusion_stat_tree()$rappel[nom],
            br(),
            strong("Precision="),
            confusion_stat_tree()$precision[nom],
            br(),
            strong("Mesure ="),
            confusion_stat_tree()$mesure[nom]
          )
        )
      })
      
      
    })
  }
})