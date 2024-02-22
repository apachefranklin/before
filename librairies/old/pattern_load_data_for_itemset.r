library(RMySQL)

db=dbConnect(MySQL(),host="localhost",password="",user="root", dbname="totoshopping")

#maintenant on selctionne les donnees en fonction du numero de la piece

data_db=dbGetQuery(db,"select Ref_article from toto_vente group by Date_vente,Num_client")
