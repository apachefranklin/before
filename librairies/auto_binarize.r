
##cette fonction doit binariser et faire une binarization special pour la classe a predire
##Elle est representer par le num_col_to_predict
##Dans la boucle de binarisation
##Si cette colonne est rencontre alors des colonnes de subtities lui seront creer
##quelque soit son nombre de facto si a jamais il s'agit d'un facteur
##On renvera une liste de formule(Contenant les noms de cette colonnes) qu'on utilisera pour les
##On conservera aussi la position finale de la colone a binariser
auto_binarize=function(data_frame,num_col_to_predict=-1){
  dimension=dim(data_frame)
  col_names=colnames(data_frame)
  #creation d'un nouveau jeu de donnees
  new_data=as.data.frame(matrix(nrow = dimension[1]))
  new_col_names=c()
  i_ncn=1 #iterateur sur les nouveaux noms de colonnnes
  indice_to_remove=c()
  i_itm=1 #iterateur sur les indices a retirer
  j=1
  new_col_name_to_predict=c() #cette colone contiendra les noms des colonnes formmer a partir des colonnes a predire
  if(num_col_to_predict!=-1){
    new_col_name_to_predict[1]=col_names[num_col_to_predict]
  }
  for(i in 1:dimension[2]){
   class_col=class(data_frame[,i])
  current_col=data_frame[,i]
   if(class_col=='factor'){
     ##on recupere les valeurs unique de cette colonne
      different=unique(current_col)
      nb_different=length(different)
      if(nb_different==1){
        ##on conclu que la colonne n'apporte aucune information et on a la retire
        data_frame=data_frame[,-i]
      }
     else if(nb_different==2){
        current_col=as.vector(current_col)
        current_col[current_col==different[1]]=0
        current_col[current_col==different[2]]=1
        
        data_frame[,i]=as.numeric(current_col)
      }
      else{
        #ceci signifie que le level est superieur est a 2
        #nous devons creer de nouvelles colonnes
        indice_to_remove[i_itm]=i
        i_itm=i_itm+1
        i_nctp=1
          for(v in different){
            col_name=paste(col_names[i],v,sep = "")
            col_to_add=rep(0,dimension[1])
            col_to_add[data_frame[,i]==v]=1
            new_data[,j]=col_to_add
            new_col_names[i_ncn]=col_name
            i_ncn=i_ncn+1
            j=j+1
            if(i==num_col_to_predict){
              new_col_name_to_predict[i_nctp]=col_name
              i_nctp=i_nctp+1
            }
          }
      

      }
   }
  
  } #fin de la boucle for
  
    if(j>1){
      colnames(new_data)=new_col_names
      data_frame=cbind(data_frame,new_data)
      data_frame=data_frame[,-indice_to_remove]
    }
  retour=list()
  retour$data=data_frame
  retour$col_prediction=new_col_name_to_predict ##ceci c'est pour les reseaux de neurones
  return(retour)
}