#function to get the column mode
get_column_type=function(vecti){
  u=vecti[1]
  print(paste("U avant veaut ",vecti[1]))
  g=as.numeric(u)
  print(paste("Voici u=",u," et g=",g))
  if(is.na(g)){
    return ("character")
  }
  else{
    return ("numeric")
  }
}

#Fonction qui recupere le mode dun vecteur ou un facteur
get_modal_value=function(v){
  uniqv=unique(v)
  return (uniqv[which.max(tabulate(match(v,uniqv)))])
}

#fonction qui trace le plot d'un arbre de decicion

plot_decision_tree=function(treeToPlot,treename=""){
  plot(treeToPlot,main=paste("Abre de decision de ",treename))
  text(treeToPlot)
}

#fonction qui prends n'importe quel dataframe en prametre et la binarise
binarize_frame=function(data_frame){
  #on binarize les chaines de cractere et rien d'autre
  col_name=colnames(data_frame)
  dimension=dim(data_frame)
  new_data=as.data.frame(matrix(nrow=dimension[1]))
  news_names=c()
  indice_nnames=1
  indice_to_remove=c()
  itr=1
  j=1
  for(i in 1:dimension[2]){
    colonne_courante=as.vector(data_frame[,i])
    col_mode=get_column_type(colonne_courante) #on rcupere le type de la colomun
    print(colonne_courante)
    print(paste(i," f ",col_mode))
    if(col_mode!="numeric" && col_mode!="integer"){
      different=unique(data_frame[,i])
        if(length(different)==2){
          colonne_courante[colonne_courante==different[1]]=0
          colonne_courante[colonne_courante==different[2]]=1
          data_frame[,i]=colonne_courante
        }
      else{
        indice_to_remove[itr]=i
        itr=itr+1
        for(item in different){
          nouvelle_colone=rep(0,dimension[1])
          nouvelle_colone[colonne_courante==item]=1
          news_names[j]=paste(col_name[i],".",item,sep = "")
          new_data[,j]=nouvelle_colone
          j=j+1
        }
      }
    }
      if(j>1){
        colnames(new_data)=news_names
        data_frame=cbind(data_frame,new_data)
        data_frame=data_frame[,-indice_to_remove]
      }
  }
  
  return (data_frame)
}
#fin de la fonction binarisation

