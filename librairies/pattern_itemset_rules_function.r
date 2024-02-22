library(arules)
library(RMySQL)

getRuleOrItems = function(dataset,
                            support,
                            confiance,
                            eTarget = "frequent itemsets",
                            tycontains = "") {
  trans1 = as(dataset, "transactions") #onn transforme en transaction
  
  itemFrequent = apriori(trans1,
                         parameter = list(
                           supp = as.numeric(support) / 100,
                           conf = as.numeric(confiance) / 100,
                           target = eTarget
                         ))

  return(itemFrequent)
}



# #cette fonctionpermet de charger les donnes qui ont deja ete traiter a la base
# loadPretraitedData=function(){
#   ltransaction=readRDS("data/list_transaction.rds")
#   return(ltransaction)
# }
# #fin de la fonction chargement des donnes pretraiter
# 
# #cette fonctionpermettra de pretraiter les donneees
# pretraitedData=function(){
#   db=dbConnect(MySQL(),host="localhost",user="root",password="", dbname="totoshopping")
#   
#   listeDate=dbGetQuery(db,"select distinct(Date_vente) from toto_vente") ##retourne un type liste
#   
#   listeClient=dbGetQuery(db,"select distinct(Num_client) from toto_vente") ##retourne un type liste
#   i=1
#   listTransaction=list();
#   for(date in listeDate[[1]]){
#     #print(date)
#     for(client in listeClient[[1]] ){
#       req=paste("select distinct(Ref_article) from toto_vente where Date_vente='",date,"' and Num_client='",client,"'",sep = "");
#       vente=dbGetQuery(db,as.character(req))
#       l=length(vente[[1]])
#       if(l>0){
#         listeArticle=vector()
#         j=1
#         for(k in vente[[1]]){
#           if(is.na(k)==FALSE){
#             if(is.na(match(k,listeArticle))==TRUE){
#               listeArticle[j]=k
#               j=j+1
#             }
#           }
#           
#         }
#         if(length(listeArticle)>0){
#           listTransaction[[i]]=listeArticle
#           i=i+1
#         }
#         
#       }
#     }
#   }
#   dbDisconnect(db)
#   return(listTransaction)
# }
# 
# #fin de la fonction de pretraitement
# 
# 
# #cette fonction permet de carger toutes les donnes de la bd
# loadAllData=function(){
#   db=dbConnect(MySQL(),host="localhost",user="root",password="", dbname="totoshopping")
#   listeVente=dbGetQuery(db,"select * from toto_vente where Date_vente!=NULL and Ref_article!=NULL and Num_piece!=NULL and Designation!=NULL order by id desc");
#   dbDisconnect(db)
#   return (listeVente)
# }
# #fin de la fonction qui charge toute les donnes de la bd
# 
# # 
# # library(RMySQL)
# # 
# # #cette fonctionpermet de charger les donnes qui ont deja ete traiter a la base
# # loadPretraitedData=function(){
# #   ltransaction=readRDS("list_transaction.rds")
# #   return(ltransaction)
# # }
# # #fin de la fonction chargement des donnes pretraiter
# 
# #cette fonctionpermettra de pretraiter les donneees
# pretraitedData=function(){
#   db=dbConnect(MySQL(),host="localhost",user="root",password="", dbname="totoshopping")
#   
#   listeDate=dbGetQuery(db,"select distinct(Date_vente) from toto_vente") ##retourne un type liste
#   
#   listeClient=dbGetQuery(db,"select distinct(Num_client) from toto_vente") ##retourne un type liste
#   i=1
#   listTransaction=list();
#   for(date in listeDate[[1]]){
#     #print(date)
#     for(client in listeClient[[1]] ){
#       req=paste("select distinct(Ref_article) from toto_vente where Date_vente='",date,"' and Num_client='",client,"'",sep = "");
#       vente=dbGetQuery(db,as.character(req))
#       l=length(vente[[1]])
#       if(l>0){
#         listeArticle=vector()
#         j=1
#         for(k in vente[[1]]){
#           if(is.na(k)==FALSE){
#             if(is.na(match(k,listeArticle))==TRUE){
#               listeArticle[j]=k
#               j=j+1
#             }
#           }
#           
#         }
#         if(length(listeArticle)>0){
#           listTransaction[[i]]=listeArticle
#           i=i+1
#         }
#         
#       }
#     }
#   }
#   dbDisconnect(db)
#   return(listTransaction)
# }
# 
# #fin de la fonction de pretraitement


# #cette fonction permet de carger toutes les donnes de la bd
# loadAllData=function(){
#   db=dbConnect(MySQL(),host="localhost",user="root",password="", dbname="totoshopping")
#   listeVente=dbGetQuery(db,"select Num_piece from toto_vente where group by Date_vente");
#  dbDisconnect(db)
#    return (listeVente)
# }
# #fin de la fonction qui charge toute les donnes de la bd