library(mice)
library(tidyverse)
library(DescTools)
library(mlr)
library(VIM)
library(missForest)
library(OpenML)

data <- boys
data <- getOMLDataSet(55L)
data <- data$data

# data[, 9] <- as.factor(ifelse(data[, 9] == "west", 0, 1))
target <- "reg"

evaluate_imputation <- function(data, target) {
  ### Funkcja przyjmuje jako argument ramkę danych, wykonuje na niej 5 różnych imputacji,
  ### a następnie porównuje wyniki imputacji przy pomocy modelu
  
  ## Imputacja
  
  # Ramka bez kolumn zawierajacych NA
  data_rm_cols <- data %>% select_if(~ !any(is.na(.)))
  
  # Ramka bez wierszy zawierajacych NA
  data_rm_rows <- data[complete.cases(data), ]
  
  # Ramka uzupelniona średnią (w kolumnach numerycznych) lub modą (w innych)
  data_insert_mean <- data
  for(i in 1:ncol(data_insert_mean)) {
    data_insert_mean[is.na(data_insert_mean[, i]), i] <- ifelse(class(data_insert_mean[, i])[1] != "numeric", names(sort(table(data_insert_mean[, i]), decreasing = TRUE))[1], mean(data_insert_mean[, i], na.rm = TRUE))
  }
  
  # Imputacja funkcją mice
  data_mice <- data
  imp <- mice(data_mice, m = 5, maxit = 5)
  data_mice <- complete(imp)
  
  # imputacja z VIM
  
  # knn - najbliżsi sąsiedzi
  data_vim_knn <- kNN(data, imp_var = FALSE) 
  # dodaje kolumny z koncówka _imp, TRUE jesli imputowane, inaczej FALSE -> imp_var FALSE to usuwa
  
  # irmi - jakies smieszne regresje
  data_vim_irmi <- irmi(data, imp_var = FALSE) # dodaje te kolumny które uzupełnia, jak wyżej T/F
  
  # hotdeck - losowo wybrana wartość
  data_vim_hotdeck <- hotdeck(data, imp_var = FALSE) # podwaja, jak w knn
  
  # imputacja missForest
  missForest_imp <- missForest(data) # zwraca liste
  data_missForest <- missForest_imp$ximp
  
  ## imputacja Amelia ? 
  
  summary(data_vim_knn)
  summary(data_vim_irmi)
  summary(data_vim_hotdeck)
  summary(data_missForest)
  
  ## Model gbm
  
  # data_rm_rows
  # 
  # n <- sample(1:nrow(data_rm_rows), 0.7* nrow(data_rm_rows))
  # data_train <- data_rm_rows[n,]
  # data_test <- data_rm_rows[-n,]
  # 
  # task <- makeClassifTask(data = data_train, target = target)
  # learner <- makeLearner("classif.gbm", predict.type = "prob")
  # model <- train(learner, task)
  # 
  # prediction <- predict(model, newdata = data_test)
  # performance <- performance(prediction, measure = "auc")
}
