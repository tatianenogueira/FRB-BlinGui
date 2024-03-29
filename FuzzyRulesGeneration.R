
install.packages("FuzzyR")
install.packages("frbs")
install.packages("BBmisc")
install.packages("caret")

########################M�TODOS DE CLASSIFICA��O########################### ############# 

#-"FRBCS.W": sistemas de classifica��o baseados em regras difusas com fator de pondera��o baseado no m�todo de Ishibuchi para lidar com tarefas de classifica��o. 
#-"FRBCS.CHI": sistemas de classifica��o baseados em regras fuzzy baseados no m�todo de Chi para lidar com tarefas de classifica��o. 
#-"GFS.GCCL": O m�todo de Ishibuchi baseado na aprendizagem competitiva e cooperativa gen�tica para lidar com tarefas de classifica��o. 
#-"FH.GBML": O m�todo de Ishibuchi baseado na hibridiza��o da aprendizagem competitiva cooperativa gen�tica e Pittsburgh para lidar com tarefas de classifica��o.
#-"SLAVE": algoritmo de aprendizagem estrutural em ambiente vago para lidar com tarefas de classifica��o.

library(FuzzyR)
library(frbs)
library(caret)
library(BBmisc)

help(sum)

#carrega o banco 
load<-read.csv("todas.csv") # carrega arquivos
dt <- read.csv("todas.csv", head=T, sep=",") # cria um objeto com os dados 

#carrega o banco agrupameto
#load<-read.csv("dadosagrupamento.csv") # carrega arquivos
#dadosagrupamento<- read.csv("dadosagrupamento.csv", head=T, sep=";") # cria um objeto com os dados 


#normaliza��o completa dos dados
#dtva<-normalize(dtva, method = "range", range = c(0, 1))

#normaliza��o apenas dos atributos. A classe deve permanecer a mesma e ser num�rica
dtva$distance <- with(dtva, (distance - min(distance)) / (max(distance) - min(distance)))
dtva$velocity <- with(dtva, (velocity - min(velocity)) / (max(velocity) - min(velocity)))
dtva$acceleration <- with(dtva, (acceleration - min(acceleration)) / (max(acceleration) - min(acceleration)))


#Essa semente evita que seja encontrado um resultado diferente a cada rodada
set.seed(0451)

#Particionando os dados em 10 folds (10-fold-cross-validation)
inTrain <- createDataPartition(y = dt$risk,
                               p = .9,
                               list = FALSE, times=10)

#Criando um data frame para armazenar o erro de cada fold
error_df <- data.frame(matrix(ncol = 2, nrow = ncol(inTrain)))
colnames(error_df) <- c('test_error', 'fold')

#Criando um data frame para armazenar a acur�cia de cada fold
accuracy_df <- data.frame(matrix(ncol = 2, nrow = ncol(inTrain)))
colnames(accuracy_df) <- c('test_accuracy', 'fold')

#Criando um data frame para armazenar a quantidade de regras cada fold
rules_df <- data.frame(matrix(ncol = 2, nrow = ncol(inTrain)))
colnames(rules_df) <- c('#rules', 'fold')

#Executando o gerador de regras para cada parti��o aleat�ria
for(i in 1:nrow(error_df)){
  
  #Obtendo os conjuntos de teste e treinamento de cada fold
  data.train <- dt[inTrain[,i],]
  data.tst <- dt[-inTrain[,i],]
  real.dist <- data.tst$risk
  
  #Calculando o intervalo de valores dos atributos, exceto a classe
 range.data.input <- apply(dt[, -ncol(dt)], 2, range)
  
 #range.data.wm <- apply(data.train, 2, range)
  
  
  #Selecionando o tipo de fun��o de perti�ncia
  type.mf <-"TRIANGLE"
  #type.mf<-"TRAPEZOID"
  #type.mf<-"GAUSSIAN"
  
  #Selecionando a quantidade de termos lingu�sticos
 #num.labels <- 3
 num.labels <-5
  
  #Selecionando a t-norma
  type.tnorm = "MIN"
  #type.tnorm = "MAX"
  
  #Selecionando a s-norma
  type.snorm = "MIN"
  #type.snorm = "MAX"
  
  #Selecionando o m�todo de implica��o
  type.implication.func = "ZADEH"
  
  control <- list(num.class=3, num.labels=num.labels, type.mf=type.mf, type.tnorm = type.tnorm, type.snorm = type.snorm, type.implication.func = type.implication.func, name = "Riscos de Colisao")
  
  #method.type<-"FRBCS.W"
  #method.type <- "FRBCS.CHI"
  method.type <-"GFS.GCCL"
 #method.type <-"FH.GBML"
  #method.type <-"SLAVE"
  
  #method.type <-"DEFINS"
  
  #method.type <-"WM"
  
  
    #Executar o gerador de regras
  obj<-frbs.learn (data.train, range.data.input, method.type=method.type, control)
  pred <- predict(obj, data.tst[,-ncol(data.tst)])
  
  #Plotar as fun��es de pertin�ncia
  plotMF(obj)
  
  #Verificar os par�metros e as regras
  summary(obj)
  
  #Encontrando o erro por fold
  err <- mean(ifelse(real.dist != pred, 1, 0))
  error_df[i,'test_error'] <- err
  error_df[i, 'fold'] <- i
  
  #Encontrando a quantidade de regras por fold
  rules_df[i,'#rules'] <- nrow(obj$rule)
  rules_df[i, 'fold'] <- i
  
  #Encontrando a acur�cia por fold
  sum(pred != real.dist)
  (pred != real.dist)
  acuracia <- (1-err)*100
 
  accuracy_df[i,'test_accuracy'] <- acuracia
  accuracy_df[i, 'fold'] <- i
 
  acuracia
   
}

#Erro obtido ap�s x folds
mean(error_df[,'test_error'])

#Acur�cia obtida ap�s x folds
mean(accuracy_df[i,'test_accuracy'])

#Quantidade m�dia de regras obtidas ap�s x folds
mean(rules_df[i,'#rules'])




#singh


dados<-read.csv("todas.csv") #carrega a base de dados
dado<-dados[0:3]
dado
install.packages("xyplot")
library(lattice)

serietf<-ts(dado)#gera uma s�rie temporal com os dados
serie
xyplot(serie, superpose = TRUE) 

plot(serie) # gera o gr�fico da serie
s<-ts(dado)
s
plot(s)
install.packages("AnalyzeTS")
library(AnalyzeTS)

options(max.print = 2000)

fuzzy.ts1(s,n=5,type="Chen",trace=TRUE, plot=TRUE,grid=TRUE)

fuzzy.ts1(s,n=5,type="Singh",trace=TRUE, plot=TRUE,grid=TRUE)

fuzzy.ts1(s,n=5,type="Heuristic",trace=TRUE, plot=TRUE,grid=TRUE)


a<-fuzzy.ts1(s,n=5,type="Chen-Hsu",plot=1)
b<-ChenHsu.bin(a$table1,n.subset=c(1,1,1,1,1))
chenhsu5<-fuzzy.ts1(s,type="Chen-Hsu",bin=b, plot=1,trace=1)
chenhsu5

install.packages("zoo")
library(zoo)
library(XLConnect)
library(lubridate)
library(ggplot2)

