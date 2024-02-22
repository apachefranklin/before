#Q3.1  Suppression des lignes contenant les valeurs manquantes
delete_na_value=function(data_table){
  dimension=dim(data_table)
  for(i in 1:dimension[2]){
    data_table=data_table[!is.na(data_table[,i]),]
    
  }
  return (data_table)
}


#Q3.2 fonction qui remplace les valeurs manquantes par le mode
replace_by_modal_value=function(data_table){
  if(is.data.frame(data_table) || is.list(data_table)){
    dimension=dim(data_table)
    for(i in 1:dimension[2]){
      colonne_courante=data_table[,i]
      colonne_courantes2=colonne_courante[!is.na(colonne_courante)]
      mode_courant=get_modal_value(colonne_courantes2)
      colonne_courante[is.na(colonne_courante)]=mode_courant
      data_table[,i]=colonne_courante
    }
  }
  else{
    #si nous avons faire a un faceur ou une colonne
    colonne_courante2=data_table[!is.na(data_table)]
    mode_courant=get_modal_value(colonne_courante2)
    data_table[is.na(data_table)]=mode_courant
  }
  
  return (data_table)
}

#fonction pour remplacer par les valeurs moyennes
replace_na_by_mean=function(vecor_fa){
  sans_na=vecor_fa[!is.na(vecor_fa)]
  mode_courant=get_modal_value(sans_na)
  vecor_fa[is.na(vecor_fa)]=mode_courant
  return (as.factor(vecor_fa))
}

#edit(data)
#data_by_mode=replace_by_modal_value(data) #on remplace les valeurs manquantes par le mode

#Q3.3 algorithme qui remplace par la moyenne s'il s'agit d'un numerique et par le mode s'il s'agit d'uncategoriel   
f_mode_moyenne=function(data_table){
  mode_colone=""
  dimension=dim(data_table)
  for(i in dimension[2]){
    colonne_courante=data_table[,i]
    if(class(colonne_courante)=="numeric"){
      data_table[,i]=replace_na_by_mean(data_table[,i])
    }
    else{
      data_table[,i]=replace_by_modal_value(data_table[,i])
    }
  }
  
  return (data_table)
}