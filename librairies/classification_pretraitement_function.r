#Q3.1  Suppression des lignes contenant les valeurs manquantes
delete_na_value = function(data_table) {
  dimension = dim(data_table)
  for (i in 1:dimension[2]) {
    data_table = data_table[!is.na(data_table[, i]), ]
  }
  return (data_table)
}


#Q3.2 fonction qui remplace les valeurs manquantes par le mode
replace_by_modal_value = function(data_table) {
  if (is.data.frame(data_table) ||
      is.list(data_table) || is.matrix(data_table)) {
    dimension = dim(data_table)
    for (i in 1:dimension[2]) {
      colonne_courante = data_table[, i]
      colonne_courantes2 = colonne_courante[!is.na(colonne_courante)]
      mode_courant = getmode(colonne_courantes2)
      colonne_courante[is.na(colonne_courante)] = mode_courant
      data_table[, i] = colonne_courante
    }
  }
  else{
    #si nous avons faire a un faceur ou une colonne
    colonne_courante2 = data_table[!is.na(data_table)]
    mode_courant = getmode(colonne_courante2)
    data_table[is.na(data_table)] = mode_courant
  }
  
  return (data_table)
}

#fonction pour remplacer par les valeurs moyennes
replace_na_by_mean = function(vecor_fa) {
  sans_na = vecor_fa[!is.na(vecor_fa)]
  mode_courant = getmode(sans_na)
  vecor_fa[is.na(vecor_fa)] = mode_courant
  return (as.vector(vecor_fa))
}

#edit(data)
#data_by_mode=replace_by_modal_value(data) #on remplace les valeurs manquantes par le mode

#Q3.3 algorithme qui remplace par la moyenne s'il s'agit d'un numerique et par le mode s'il s'agit d'uncategoriel
# f_mode_moyenne=function(data_table){
#   data_table[,1]=replace_by_modal_value(data_table[,1])
#   data_table[,4]=replace_by_modal_value(data_table[,4])
#   data_table[,5]=replace_by_modal_value(data_table[,5])
#   data_table[,6]=replace_by_modal_value(data_table[,6])
#   data_table[,7]=replace_by_modal_value(data_table[,7])
#   data_table[,9]=replace_by_modal_value(data_table[,9])
#   data_table[,10]=replace_by_modal_value(data_table[,10])
#   data_table[,12]=replace_by_modal_value(data_table[,12])
#   data_table[,13]=replace_by_modal_value(data_table[,13])
#   data_table[,16]=replace_by_modal_value(data_table[,16])
#
#   data_table[,2]=replace_na_by_mean(data_table[,2])
#   data_table[,3]=replace_na_by_mean(data_table[,3])
#   data_table[,8]=replace_na_by_mean(data_table[,8])
#   data_table[,11]=replace_na_by_mean(data_table[,11])
#   data_table[,14]=replace_na_by_mean(data_table[,14])
#   data_table[,15]=replace_na_by_mean(data_table[,15])
#
#   return (data_table)
# }

f_mode_moyenne = function(data_table) {
  dimension = dim(data_table)
  for (i in seq(along <- dimension[2])) {
    if (class(data_table[,i]) == 'factor') {
      data_table[,i] = replace_by_modal_value(data_table[,i])
    } 
    else{
      
      data_table[,i] = replace_na_by_mean(data_table[, i])
      
    }
  }
  return (data_table)
}