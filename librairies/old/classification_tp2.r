library(rpart)
library(neuralnet)
library(factoextra)
source("librairies/classification_global_function.r")
source("librairies/classification_pretraitement_function.r")
source("librairies/auto_binarize.r")
#tp2
#Question1 charger les donnes dans la variable data
data_bq=read.table("data/classification/crx.data.txt",sep = ",",na.strings = "?")
colnames(data_bq)=paste("V",1:16,sep="")
auto_binarize(data_bq)
  #Q2 commenttons les distributions
    #summary(data)

#Q3 pretritements de donness
  # print("1. Une des methodes est de supprime des lignes correspondantes aux donnees manquantes")
  # print("2. Remplacer les donnees manquantes par la moyenne s'il sa'git de donnee continue")
  # print("3. Remplacer les donnees manquantes par la valeur la plus frequentes (le mode)")


    
  
     #delete_na_value(data)
     data_to_use1=delete_na_value(data_bq)
     d23=auto_binarize(data_to_use1)
     edit(d23$data)
     edit(data_to_use1)
     nn=neuralnet(V16~.,data=d23$data,hidden = c(5))
     #print(dim(data_without_na))
     #Q3.2
     data_to_use2=replace_by_modal_value(data_bq)
      auto_binarize(data_to_use2)
      #Q3.3
     data_use3=f_mode_moyenne(data_bq)
     bin_auto= auto_binarize(data_use2,16)
     # edit(scale(bin_auto$data,center = T,scale = T))
     k_mean=kmeans(scale(bin_auto$data,center = T,scale = T),centers = 8,nstart = 5)
     #clusplot(scale(bin_auto$data,center = T,scale = T),col=k_mean$cluster)
     to_remove=get_indice_from_vect(colnames(bin_auto$data),bin_auto$col_prediction)
     edit(bin_auto$data[,-to_remove])
     fviz_cluster(k_mean,bin_auto$data[,-to_remove],geom='points')
     clusplot(data_to_use2[,-16],k_mean$cluster)
     # frank=as.factor(data[,1])
      # print(length(frank=='?'))
      # print(frank[1])
  #edit(data)
  
#Q4 a)Choix du jeu d'entrainement et de test
      nrows=nrow(data_to_use2)
      lines_to_train=sample(x = 1:nrows,size =(2*nrows)/3)
      train_data=data_to_use2[lines_to_train,]
      test_data=data_to_use2[-lines_to_train,]
    print(length(test_data$V16))
      #b) b.1) Gestion de l'arbre de decision
      
      banq_tree=rpart(V16~.,train_data)
      plot_decision_tree(banq_tree,"Donnee de banque")
    #Precditcion avec l'arbre de decision
       predict_with_tree= predict(banq_tree,test_data[,-16],type=c("class"))
       print(length(predict_with_tree))
       matrice_confusion_arbre=table(predict_with_tree,test_data$V16)
      summary_confusion(matrice_confusion_arbre)
       #b.2) Construction du reseaux de neurones
     
        data_for_neural=binarize_frame(data_to_use2)
        train_neural=data_for_neural[lines_to_train,]
        test_neural=data_for_neural[-lines_to_train,]
        table_train_neural=neuralnet(V16~.,data_for_neural,rep = 4)
#il faut qu'on comprenne pourquoi la colonne v2 dit etre numeric
       
         