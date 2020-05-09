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

new_function <- function(data, target, data_name) {
  
  directory <- paste0("./files/",data_name)
  setwd(directory)
  
  model <- function(data_test, data_train, model_name) {
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
    learner <- mlr_learners$get(model_name)
    learner$predict_type = "prob"
    learner$train(task)
    
    # prediction
    prediction <- learner$predict_newdata(data_test)
    performance<-prediction$score(c(msr("classif.auc"), msr("classif.bacc")))
    
    return(performance)
  }
  test_mean <- read.csv2("test_mean.csv")
  train_mean <- read.csv2("train_mean.csv")
  test_mice <- read.csv2("test_mice.csv")
  train_mice <- read.csv2("train_mice.csv")
  test_vim_knn <- read.csv2("test_vim_knn.csv")
  train_vim_knn <- read.csv2("train_vim_knn.csv")
  test_vim_hotdeck <- read.csv2("test_vim_hotdeck.csv")
  train_vim_hotdeck <- read.csv2("train_vim_hotdeck.csv")
  test_softImpute <- read.csv2("test_softImpute.csv")
  train_softImpute <- read.csv2("train_softImpute.csv")
  
  
  perf_insert_mean <- model(test_mean, train_mean, "classif.rpart")
  perf_mice <- model(test_mice, train_mice, "classif.rpart")
  perf_vim_knn <- model(test_vim_knn,train_vim_knn, "classif.rpart")
  perf_vim_hotdeck <- model(test_vim_hotdeck, train_vim_hotdeck, "classif.rpart")
  perf_softImpute <- model(test_softImpute,train_softImpute, "classif.rpart")
   
  perf_combined <- as.data.frame(rbind( 
     perf_insert_mean, 
     perf_mice, 
     perf_vim_knn, 
     perf_vim_hotdeck,
     perf_softImpute))
   colnames(perf_combined)<-c("auc", "bacc")
  setwd("~/Projekt_WB")
  return(perf_combined)
}
