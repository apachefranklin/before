library(rpart)
library(neuralnet)

source("function/global_function2.r")
source("function/pretraitement_function2.r")
#tp2
#Question1 charger les donnes dans la variable data
data_bq=read.table("data/crx.data.txt",sep = ",",na.strings = "?")
colnames(data_bq)=paste("V",1:16,sep="")
  #Q2 commenttons les distributions
    #summary(data)

#Q3 pretritements de donness
  # print("1. Une des methodes est de supprime des lignes correspondantes aux donnees manquantes")
  # print("2. Remplacer les donnees manquantes par la moyenne s'il sa'git de donnee continue")
  # print("3. Remplacer les donnees manquantes par la valeur la plus frequentes (le mode)")


    
  
     #delete_na_value(data)
     data_to_use1=delete_na_value(data_bq)
     #print(dim(data_without_na))
     #Q3.2
     data_to_use2=replace_by_modal_value(data_bq)
  #Q3.3
      data_use3=f_mode_moyenne(data_bq)
      
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
     # plot_decision_tree(banq_tree,"Donnee de banque")
    #Precditcion avec l'arbre de decision
       predict_with_tree= predict(banq_tree,test_data[,-16],type=c("class"))
       print(length(predict_with_tree))
       matrice_confusion_arbre=table(predict_with_tree,test_data$V16)
    
       #b.2) Construction du reseaux de neurones
     
        data_for_neural=binarize_frame(data_to_use2)
        train_neural=data_for_neural[lines_to_train,]
        test_neural=data_for_neural[-lines_to_train,]
        table_train_neural=neuralnet(V16~.,data_for_neural,rep = 4)
#il faut qu'on comprenne pourquoi la colonne v2 dit etre numeric
       
         