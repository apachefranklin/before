library(xlsx)
#Fonction qui recupere le mode dun vecteur ou un facteur
getmode=function(v){
  uniqv=unique(v)
  return (uniqv[which.max(tabulate(match(v,uniqv)))])
}

#fonction qui trace le plot d'un arbre de decicion

plot_decision_tree=function(treeToPlot,treename=""){
  plot(treeToPlot,main=paste("Abre de decision de ",treename))
  text(treeToPlot)
}

#fonction qui prends n'importe quel dataframe en prametre et la binarise
binarize_frame=function(data_frame,vindice_to_binarize){
  data_frame=as.data.frame(data_frame)
  dimension=dim(data_frame)
  nbligne=dimension[1]
  #le but ici est de binarize les colonnes donc
  #les indices sont passe en paramettre
  #on va gerer cela avec le levels
  news_names=c() #ici un vecteur de nouveaux noms
  indice_to_remove=c()
  itr=1
  allnames=colnames(data_frame)
  other_data=as.data.frame(matrix(nrow = nbligne))
  print(dim(other_data))
  j=1
  for (i in vindice_to_binarize){
    different=unique(data_frame[,i])
    colframe=as.vector(data_frame[,i])
    # print(different[1])
    # print(different[2])
    if(length(different)==2){
      colone=1:dimension[1]
      colframe[colframe==different[1]]='0'
      colframe[colframe==different[2]]='1'
      data_frame[,i]=as.vector(as.list.numeric_version(colframe))
    }
    else{
      indice_to_remove[itr]=i
      itr=itr+1
      for(value in different){
        news_names[j]=paste(allnames[i],".",value, sep="")
        colonne=rep('0',nbligne)
        colonne[colframe==value]=1
        other_data[,j]=as.vector(as.list.numeric_version(colonne))
        j=j+1
      }
    }
  }
  data_frame=data_frame[,-indice_to_remove]
  for(l in dim(data_frame)[2]){
    data_frame[,l]=as.vector(as.list.numeric_version(data_frame[,l]))
  }
  
  if(j>1){
    colnames(other_data)=news_names
    
    data_frame=cbind.data.frame(data_frame,other_data)
    
  }
    
  return (data_frame)
}
#fin de la fonction binarisation


#fonction qui renvoie le jeu de donnnes d'entrainement et le jeu de donne test
Get_train_test_set=function(data_set,trainpercent=66.66){
  nrows=nrow(data_set)
  lines_to_train=sample(x = 1:nrows,size =(nrows*trainpercent)/100)
  train_data=data_set[lines_to_train,]
  test_data=data_set[-lines_to_train,]
  retour=list()
  retour$trainSet=train_data
  retour$testSet=test_data
  retour$all=data_set
  return (retour)
}

##une fonction qui prend une matrice de confusion
##en parametre et en resoirt les statistques
summary_confusion=function(confusion_matrix){
  precision=c() ##ceci contiendra toutes les precisions
  rappel=c() ##ceci contiendra tous les rappels
  mesure=c() ##ceci contiendra toutes les mesures
    col_names=colnames(confusion_matrix)
    row_names=rownames(confusion_matrix)
    good_prediction=0
    bad_prediction=0
    dimension=dim(confusion_matrix)
      for(i in 1:dimension[1]){
        for(j in 1:dimension[2]){
          if(i==j){
            good_prediction=good_prediction+confusion_matrix[i,j]
          }
          else{
            bad_prediction=bad_prediction+confusion_matrix[i,j]
          }
        }
      }
  ##ici on va caluler le rappels pour 
  ##pour calculer les precisions de chacun on va parcourir la liste
  #Des noms et pour chque noms on va recuperer son indice 
  #qui represente sa position en ligne et en colonne dans le tableau
  #une fois c'est idince recuperer on va faire la somme de la ligne 
  #correspondante ou la colonne coreesponde en fonction du calcul qu'on veut effectuer
    for(i in 1:dimension[1]){
      nom=col_names[i]
      somme_colonne=sum(confusion_matrix[,i])
      somme_ligne=sum(confusion_matrix[i,])
      vp=confusion_matrix[i,i]
      rappel[nom]=vp/somme_ligne
      precision[nom]=vp/somme_colonne
      ##mesure=2vp/(2vp+fn+fp)
      mesure[nom]=2*vp/(2*vp+(somme_ligne-vp)+(somme_colonne-vp))
      #ou encore
      mesure[nom]=(2*rappel[nom]*precision[nom])/(precision[nom]+rappel[nom])
    }
    retour=list()
    retour$precision=precision
    retour$mesure=mesure
    retour$rappel=rappel
    retour$good_prediction=good_prediction
    retour$bad_prediction=bad_prediction
    retour$all_prediction=bad_prediction+good_prediction
    
    return (retour)
}

##fonction qui prends un vecteur en parametre et un autre et renvoir un vecteur de 
##Taille du second vecteur contenant les positions de l'
get_indice_from_vect=function(v1,v2){
  v3=c()
  iv3=1
  iv2=2
  for(i in 1:length(v2)){
    for(j in  1:length(v1)){
      if(v1[j]==v2[i]){
        v3[iv3]=j
        iv3=iv3+1
      }
    }
  }
  return(v3)
}


###Fonction pour l'export des donness
export_file_data=function(file_extension,data_to_save,file){
  if(file_extension=="csv"){
    write.csv(data_to_save,file,row.names = FALSE)

  }
  else if(file_extension=="xlsx"){
    write.xlsx(data_to_save,file,row.names = FALSE)
  }
  else if(file_extension=="rds"){
    saveRDS(data_to_save,file)
  }
  else{}
}

##fonction qui renvoie le nom d'un fichier
##Juste en collant a l'extension
file_name=function(name,extension){
  return(paste(name,extension,sep = "."))
}