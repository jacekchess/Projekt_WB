library(mice)
library(tidyverse)
library(DescTools)
library(mlr)
library(mlr3)
library(mlr3learners)
library(mlr3measures)
library(Metrics)
library(VIM)
library(softImpute)
library(OpenML)
library(imputeMissings)

imputations_performance <- function(target, data_name, model_name) {
  # przyjmuje target, nazwę zbioru (string) oraz rodzaj modelu do wytrenowania na wszystkich imputacjach tego zbioru
  
  model <- function(data_test, data_train, model_name) {
    # takes test and train dataset and performs rpart modelling
    # returns auc and  balanced acc measures
    
    # MLR
    # task <- makeClassifTask(data = data_train, target = target)
    # learner <- makeLearner(model_name, predict.type = "prob")
    # model <- train(learner, task)
    # 
    # prediction <- predict(model, newdata = data_test)
    # performance <- performance(prediction, measure = list(auc,acc))
    
    # MLR3
    task <- TaskClassif$new(id="task", backend = data_train, target = target)
    
    # choosing learner
    learner <- mlr_learners$get(model_name)
    learner$predict_type = "prob"
    learner$train(task)
    
    # prediction
    prediction <- learner$predict_newdata(data_test)
    
    performance<-prediction$score(msr("classif.fbeta"))
    
    return(performance)
  }
  directory<-paste0("./files/",data_name)
  test_mean <- read.csv2(paste0(directory,"/test_mean.csv"))
  train_mean <- read.csv2(paste0(directory,"/train_mean.csv"))
  test_mice <- read.csv2(paste0(directory,"/test_mice.csv"))
  train_mice <- read.csv2(paste0(directory,"/train_mice.csv"))
  test_vim_knn <- read.csv2(paste0(directory,"/test_vim_knn.csv"))
  train_vim_knn <- read.csv2(paste0(directory,"/train_vim_knn.csv"))
  test_vim_hotdeck <- read.csv2(paste0(directory,"/test_vim_hotdeck.csv"))
  train_vim_hotdeck <- read.csv2(paste0(directory,"/train_vim_hotdeck.csv"))
  test_softImpute <- read.csv2(paste0(directory,"/test_softImpute.csv"))
  train_softImpute <- read.csv2(paste0(directory,"/train_softImpute.csv"))
  
  
  perf_insert_mean <- model(test_mean, train_mean, model_name)
  perf_mice <- model(test_mice, train_mice, model_name)
  perf_vim_knn <- model(test_vim_knn,train_vim_knn, model_name)
  perf_vim_hotdeck <- model(test_vim_hotdeck, train_vim_hotdeck, model_name)
  perf_softImpute <- model(test_softImpute,train_softImpute, model_name)
   
  perf_combined <- as.data.frame(rbind( 
     perf_insert_mean, 
     perf_mice, 
     perf_vim_knn, 
     perf_vim_hotdeck,
     perf_softImpute))
   colnames(perf_combined)<-"f1"
  return(perf_combined)
}

evaluation_188_rpart <- imputations_performance(target188,  "dataset188", "classif.rpart")
target<-target188
data_name<-"dataset188"
model_name<-"classif.rpart"
