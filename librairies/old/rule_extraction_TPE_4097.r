library(arules)

###############################code envoye par le prof##################3

#commande permettant de charger les donnes de la base de donnees
rule_db<-dbConnect(MySQL(),user="root",host="localhost",password="",dbname="rule_extraction")

#extraire les donnees (colonnes Designation et Num_piece) et les charger dans une variable
BD <- dbGetQuery(rule_db, "select Num_piece,Designation from toto_vente;")
BD <- BD[-1]

#Traiter les valeurs manquantes 
#### Il faut sélectionner toute la suite et exécuter avec CRTL+R

i=1
n=nrow(BD)  ###nombre de lignes
BD[,"Designation"] = type.convert(BD[,"Designation"], "dataframe")
m=length(levels(BD[,"Designation"]))## nombre d'éléments différents
v1=rep(0,m)
names(v1)= levels(BD[,"Designation"]) ##On utilise les noms des éléments coe nom de colonnes
v1[BD[i,"Designation"]]=1
while(BD[i,"Num_piece"]==BD[i+1,"Num_piece"]&&i<n)
{
  v1[BD[i+1,"Designation"]]=1
  i=i+1
}
rule_dataframe=matrix(v1,ncol=m,byrow=T) 

while(i<=n)
{
  i=i+1
  v1=rep(0,m)
  names(v1)= levels(BD[,"Designation"])
  v1[BD[i,"Designation"]]=1
  
  while(BD[i,"Num_piece"]==BD[i+1,"Num_piece"] && i<n)
  {
    v1[BD[i+1,"Designation"]]=1
    i=i+1
  }
  
  if(i<=n){rule_dataframe=rbind(rule_dataframe,v1)}
}
BD[,"Num_piece"] = type.convert(BD[,"Num_piece"], "dataframe")
rownames(rule_dataframe)=levels(BD[,"Num_piece"])

#transformer en transactions
tr <- as(rule_dataframe, "transactions")

#extraire les regles
itemsetFrequent <- apriori(tr, parameter=list(supp=0.001,conf=0.6,target="frequent itemsets"))
rule <- apriori(tr, parameter=list(supp=0.001,conf=0.6,target="rule"))

#plot les itemsfrequency
itemFrequencyPlot(itemsetFrequent, type="relative", support=0.008)

#plot les regles


#regle les plus pertinentes
subrules <- head(sort(rule, by="lift"), 10)

#plot les regles pertinentes


