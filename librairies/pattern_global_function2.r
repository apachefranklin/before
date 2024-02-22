library(RMySQL)

#cette fonctionpermet de charger les donnes qui ont deja ete traiter a la base
loadPretraitedData=function(){
  ltransaction=readRDS("data/pattern/list_transaction.rds")
  lcouple=readRDS("data/pattern/liste_couple.rds")
  final_transaction=list()
  for(i in 1:length(ltransaction)){
      v_transaction=ltransaction[[i]]
      v_final=c()
      j=1
      for(v in v_transaction){
        v_final[j]=lcouple[v]
        j=j+1
      }
      final_transaction[[i]]=v_final
  }
  return(final_transaction)
}
#fin de la fonction chargement des donnes pretraiter

#fonction qui prends les couples unique ref_article et designation article en parametre
get_couple_ref_desi=function(){
  db=dbConnect(MySQL(),host='localhost',user='root',passwor="",dbname="totoshopping")
  listRef=dbGetQuery(db,"select distinct(Ref_article) from toto_vente")
  listeCouple=c()
  for(v in listRef[[1]]){
    requete=paste("select distinct(Designation) from toto_vente where Ref_article='",v,"' and Designation!='' order by Designation",sep = "")
    designation=dbGetQuery(db,requete)
    listeCouple[v]=paste(designation[[1]][1],"(",v,")",sep = "")
  }
  dbDisconnect(db)
  saveRDS(listeCouple,file ="liste_couple.rds")
  return (listeCouple)
}

#cette fonctionpermettra de pretraiter les donneees
pretraitedData=function(){
  db=dbConnect(MySQL(),host="localhost",user="root",password="", dbname="totoshopping")
  
  listeDate=dbGetQuery(db,"select distinct(Date_vente) from toto_vente") ##retourne un type liste
  
  listeClient=dbGetQuery(db,"select distinct(Num_client) from toto_vente") ##retourne un type liste
  i=1
  listTransaction=list();
  for(date in listeDate[[1]]){
    #print(date)
    for(client in listeClient[[1]] ){
      req=paste("select distinct(Ref_article) from toto_vente where Date_vente='",date,"' and Num_client='",client,"'",sep = "");
      vente=dbGetQuery(db,as.character(req))
      l=length(vente[[1]])
      if(l>0){
        listeArticle=vector()
        j=1
        for(k in vente[[1]]){
          if(is.na(k)==FALSE){
            if(is.na(match(k,listeArticle))==TRUE){
              listeArticle[j]=k
              j=j+1
            }
          }
          
        }
        if(length(listeArticle)>0){
          listTransaction[[i]]=listeArticle
          i=i+1
        }
        
      }
    }
  }
  dbDisconnect(db)
  saveRDS(listTransaction,file="list_transaction.rds")
  return(listTransaction)
}

#fin de la fonction de pretraitement


#cette fonction permet de carger toutes les donnes de la bd
pattern_load_data=function(){
  db=dbConnect(MySQL(),host="localhost",user="root",password="", dbname="totoshopping")
  listeVente=dbGetQuery(db,"select * from toto_vente");
 dbDisconnect(db)
   return (listeVente)
}
#fin de la fonction qui charge toute les donnes de la bd