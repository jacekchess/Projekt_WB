library(mice)
library(tidyverse)
library(DescTools)
library(mlr)
library(VIM)
library(missForest)
library(OpenML)

# data <- boys
data <- getOMLDataSet(55L)
data <- data$data

# data[, 9] <- as.factor(ifelse(data[, 9] == "west", 0, 1))
# target <- "reg"

evaluate_imputation <- function(data, target) {
  ### Funkcja przyjmuje jako argument ramkę danych, wykonuje na niej 5 różnych imputacji,
  ### a następnie porównuje wyniki imputacji przy pomocy modelu
  
  # podział na treningowy i testowy 
  
  set.seed(123)

  n <- nrow(data)
  
  train_set = sample(n, 0.8 * n)
  test_set = setdiff(seq_len(n), train_set)
  data_train <- data[train_set,]
  data_test <- data[test_set,]
  
  ## Imputacja
  
  # Ramka bez kolumn zawierajacych NA
  data_train_rm_cols <- data_train %>% select_if(~ !any(is.na(.)))
  data_test_rm_cols <- data_test  %>% select_if(~ !any(is.na(.)))

  # Ramka bez wierszy zawierajacych NA
  data_train_rm_rows <- na.omit(data_train)
  data_test_rm_rows <- na.omit(data_test)
  #data_rm_rows <- data[complete.cases(data), ]
  
  # Ramka uzupelniona średnią (w kolumnach numerycznych) lub modą (w innych)
  data_train_insert_mean <- data_train
  data_test_insert_mean <- data_test
  for(i in 1:ncol(data_train_insert_mean)) {
    data_train_insert_mean[is.na(data_train_insert_mean[, i]), i] <- ifelse(class(data_train_insert_mean[, i])[1] != "numeric", names(sort(table(data_train_insert_mean[, i]), decreasing = TRUE))[1], mean(data_train_insert_mean[, i], na.rm = TRUE))
  }
  for(i in 1:ncol(data_test_insert_mean)) {
    data_test_insert_mean[is.na(data_test_insert_mean[, i]), i] <- ifelse(class(data_test_insert_mean[, i])[1] != "numeric", names(sort(table(data_test_insert_mean[, i]), decreasing = TRUE))[1], mean(data_test_insert_mean[, i], na.rm = TRUE))
  }
  
  # Imputacja funkcją mice
  data_train_mice <- data_train
  data_test_mice <- data_test
  imp1 <- mice(data_train_mice, m = 5, maxit = 5)
  data_train_mice <- complete(imp1)
  imp2 <- mice(data_test_mice, m = 5, maxit = 5)
  data_test_mice <- complete(imp2)
  
  # imputacja z VIM
  
  # knn - najbliżsi sąsiedzi
  data_train_vim_knn <- kNN(data_train, imp_var = FALSE) 
  data_test_vim_knn <- kNN(data_test, imp_var = FALSE) 
  # dodaje kolumny z koncówka _imp, TRUE jesli imputowane, inaczej FALSE -> imp_var FALSE to usuwa
  
  # irmi - jakies smieszne regresje
  data_train_vim_irmi <- irmi(data_train, imp_var = FALSE) # dodaje te kolumny które uzupełnia, jak wyżej T/F
  data_test_vim_irmi <- irmi(data_test, imp_var = FALSE)
  
  # hotdeck - losowo wybrana wartość
  data_train_vim_hotdeck <- hotdeck(data_train, imp_var = FALSE) # podwaja, jak w knn
  data_test_vim_hotdeck <- hotdeck(data_test, imp_var = FALSE) 
  
  # imputacja missForest
  missForest_train_imp <- missForest(data_train) # zwraca liste
  data_missForest <- missForest_train_imp$ximp
  missForest_test_imp <- missForest(data_test) # zwraca liste
  data_missForest <- missForest_test_imp$ximp
  
  ## imputacja Amelia ? 
  
  summary(data_train_vim_knn)
  summary(data_train_vim_irmi)
  summary(data_train_vim_hotdeck)
  summary(data_train_missForest)
  
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
