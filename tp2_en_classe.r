#Chargement de la library("rpart")
# Construire l'arbre de décision
ad = rpart(Species ~. , iris)

# Sortir le graphe 
plot(ad)

#Mettre une légende 
text(ad)

#Pour faire les prédictions 
predict(ad, iris[, -5]) # On enlève la colonne de la classe qui est à la 5ième colonne 


#Tirage aléatoire pour faire le jeu de données de test et de validation 

tr = sample (1:nrow(iris), 2*nrow(iris)/3)

#tr2 = sample (iris, 2*nrow(iris)/3)

# Set de validation
trainset = iris[tr, ]

# Set de test 
testset = iris[-tr, ]

# Construction de l'arre sur les données d'entrainement 
adtrainset = rpart(Species ~. , trainset)

#constrution de l'arre 
plot(adtrainset)
text(adtrainset)

# Test de l'arbre 
P = predict(adtrainset, testset[, -5],  type=c("class"))
# On teste l'arbre donné sur les données de test 


# Matrice de confusion 
table (P, testset[, 5]) 
# La matrice de confusion permet de comparer les données attendues de ceux obtenues 
# Les données obtenues sont dans P 

# ===== Entrainement avec les neuronnes ======= 

library(nnet)
# Construction du reseau de neuronnes sur le trainset
model = nnet(Species ~., trainset, 5)

# Au debut il commence avec un taux d'erreur très grand 127... puis au fur et à mesure les itérations augmentent, les valeurs diminuent


# Prédiction sur le jeu de test du model

Pmodel = predict(model, testset[, -5],  type=c("class"))

# Matrice de confusion sur le reseau de nueronnes 
table(Pmodel, testset[, 5]) 

library(neuralnet)
iris2 = iris 

# séparation 
#iristrain = iris2[sample(1:nrow(iris2), size.sample),]

iris2 = cbind(iristrain, iris2$Species == 'setosa')
iris2 = cbind(iristrain, iris2$Species == 'versicolor')
iris2 = cbind(iristrain, iris2$Species == 'virginica')
# Séparation 
iristrain = sample(1:nrow(iris2), 2*nrow(iris)/3)

nn_iristrainset = iris2[iristrain, ]
nn_iristestset = iris2[-iristrain, ]

# Construction de modèle et affichage 
nn = neuralnet(setosa+versicolor+virginica~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width, data = nn_iristrainset, hidden = c(3))

plot(nn)

#Prediction 
nn_Pmodel = predict(nn, iris[, -5])


# Regression 

t = seq (0, 20, length = 200)
y = 1 + 3*cos(4*t+2) + .2*t^2
dat = data.frame(t, y)

names(dat) = c('t', 'y')
plot(t,  y, type ='l', col=2)