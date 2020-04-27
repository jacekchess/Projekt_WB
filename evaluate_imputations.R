library(mice)
library(tidyverse)
library(DescTools)
library(mlr)
library(mlr3)
library(mlr3learners)
library(VIM)
library(softImpute)
library(OpenML)
library(imputeMissings)

data <- dataset4
target <- target4

evaluate_imputations <- function(data, target) {
  ### Funkcja przyjmuje jako argument ramkę danych, wykonuje na niej 5 różnych imputacji,
  ### a następnie porównuje wyniki imputacji przy pomocy modelu
  ## returns a 5x2 matrix where rows are imputations and columns are AUC and Balanced ACC measures
  
  # podział na treningowy i testowy 
  
  set.seed(13)

  n <- nrow(data)
  
  train_set = sample(n, 0.8 * n)
  test_set = setdiff(seq_len(n), train_set)
  data_train <- data[train_set,]
  data_test <- data[test_set,]
  
  ## Imputacja
  
  # Ramka bez kolumn zawierajacych NA
  # data_train_rm_cols <- data_train %>% select_if(~ !any(is.na(.)))
  # data_test_rm_cols <- data_test  %>% select_if(~ !any(is.na(.)))

  # Ramka bez wierszy zawierajacych NA
  # data_train_rm_rows <- na.omit(data_train)
  # data_test_rm_rows <- na.omit(data_test)
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
  # if (dim(dataset)[1]==8844 & dim(dataset)[2]==56){
  #   print("1018")
  #   imp1 <- mice(data_train_mice, m = 1, maxit = 1, nnet.MaxNWts=3000)
  #   data_train_mice <- mice::complete(imp1)
  #   imp2 <- mice(data_test_mice, m = 1, maxit = 1, nnet.MaxNWts=3000)
  #   data_test_mice <- mice::complete(imp2)
  #   print("mice")
  # }
  # else{
  imp1 <- mice(data_train_mice, method = "pmm", m = 1, maxit = 1, nnet.MaxNWts=3000)
  data_train_mice <- mice::complete(imp1)
  imp2 <- mice(data_test_mice, method = "pmm", m = 1, maxit = 1, nnet.MaxNWts=3000)
  data_test_mice <- mice::complete(imp2)
  print("mice")
  # }
  # imputacja z VIM
  
  # knn - najbliżsi sąsiedzi
  data_train_vim_knn <- kNN(data_train, imp_var = FALSE) 
  data_test_vim_knn <- kNN(data_test, imp_var = FALSE) 
  # dodaje kolumny z koncówka _imp, TRUE jesli imputowane, inaczej FALSE -> imp_var FALSE to usuwa
  print("knn")
  # hotdeck - losowo wybrana wartość
  data_train_vim_hotdeck <- hotdeck(data_train, imp_var = FALSE) # podwaja, jak w knn
  data_test_vim_hotdeck <- hotdeck(data_test, imp_var = FALSE) 
  print("hotdeck")
  # softImpute + moda dla factorów
  
  factors <- unlist(lapply(data, is.factor))
  data_train_num <- softImpute::complete(data_train[!factors], softImpute(data_train[!factors], trace=TRUE, type='svd'))
  data_train_fac <- imputeMissings::impute(data_train[factors], method='median/mode')
  data_train_softImpute <- cbind(data_train_num,data_train_fac)
  
  data_test_num <- softImpute::complete(data_test[!factors], softImpute(data_test[!factors], trace=TRUE, type='svd'))
  data_test_fac <- imputeMissings::impute(data_test[factors], method='median/mode')
  data_test_softImpute <- cbind(data_test_num,data_test_fac)
  print("softImpute")
  ## Model gbm
  
  rpart_model <- function(data_test, data_train) {
    # takes test and train dataset and performs rpart modelling
    # returns auc and  balanced acc measures
    
    # MLR
    # task <- makeClassifTask(data = data_train, target = target)
    # learner <- makeLearner("classif.rpart", predict.type = "prob")
    # model <- train(learner, task)
    # 
    # prediction <- predict(model, newdata = data_test)
    # performance <- performance(prediction, measure = list(auc,acc))
    
    # MLR3
    task <- TaskClassif$new(id = "svm", backend = data_train, target = target)
    
    # choosing learner
    learner <- mlr_learners$get("classif.rpart")
    learner$predict_type = "prob"
    learner$train(task)
    
    # prediction
    prediction <- learner$predict_newdata(data_test)
    performance<-prediction$score(c(msr("classif.auc"), msr("classif.bacc")))
    
    return(performance)
  }
  
  # perf_rm_rows <- rpart_model(data_test_rm_rows, data_train_rm_rows)
  perf_insert_mean <- rpart_model(data_test_insert_mean, data_train_insert_mean)
  perf_mice <- rpart_model(data_test_mice, data_train_mice)
  perf_vim_knn <- rpart_model(data_test_vim_knn, data_train_vim_knn)
  perf_vim_hotdeck <- rpart_model(data_test_vim_hotdeck, data_train_vim_hotdeck)
  perf_softImpute <- rpart_model(data_test_softImpute, data_train_softImpute)

  perf_combined <- as.data.frame(rbind( # perf_rm_rows,
                    perf_insert_mean, 
                    perf_mice, 
                    perf_vim_knn, 
                    perf_vim_hotdeck,
                    perf_softImpute))
  colnames(perf_combined)<-c("auc", "bacc")
  return(perf_combined)
}