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
  # if((data_name == "dataset1018" && model_name == "classif.rpart") ||
  #    (data_name == "dataset23381" && (model_name == "classif.rpart" || model_name == "classif.lda"))) {
  #   
  #   perf_combined <- transpose(as.data.frame(rep(NA, 5)))
  #   rownames(perf_combined)<-"f1"
  #   colnames(perf_combined)<-c('perf_insert_mean','perf_mice','perf_vim_knn','perf_vim_hotdeck','perf_softImpute')
  #   return(perf_combined)
  
  model <- function(data_test, data_train, model_name) {
    # takes test and train dataset and performs rpart modelling
    # returns f1 measures

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
  
  # rzutowanie zmiennej target na factor - dla bezpieczeństwa
  test_mean[,target]<-as.factor(test_mean[, target])
  train_mean[,target]<-as.factor(train_mean[, target])
  test_mice[,target]<-as.factor(test_mice[, target])
  train_mice[,target]<-as.factor(train_mice[, target])
  test_vim_knn[,target]<-as.factor(test_vim_knn[, target])
  train_vim_knn[,target]<-as.factor(train_vim_knn[, target])
  test_vim_hotdeck[,target]<-as.factor(test_vim_hotdeck[, target])
  train_vim_hotdeck[,target]<-as.factor(train_vim_hotdeck[, target])
  test_softImpute[,target]<-as.factor(test_softImpute[, target])
  train_softImpute[,target]<-as.factor(train_softImpute[, target])
  
  perf_insert_mean <- tryCatch(
    {
      model(test_mean, train_mean, model_name)
    },
    error=function(cond) {
      return(NA)
    }
  )
    
  perf_mice <- tryCatch(
    {
      model(test_mice, train_mice, model_name)
    },
    error=function(cond) {
      return(NA)
    }
  )
  perf_vim_knn <- tryCatch(
    {
      model(test_vim_knn,train_vim_knn, model_name)
    },
    error=function(cond) {
      return(NA)
    }
  )
  perf_vim_hotdeck <- tryCatch(
    {
      model(test_vim_hotdeck, train_vim_hotdeck, model_name)
    },
    error=function(cond) {
      return(NA)
    }
  )
  perf_softImpute <- tryCatch(
    {
      model(test_softImpute,train_softImpute, model_name)
    },
    error=function(cond) {
      return(NA)
    }
  )

   
  perf_combined <- as.data.frame(cbind( 
     perf_insert_mean, 
     perf_mice, 
     perf_vim_knn, 
     perf_vim_hotdeck,
     perf_softImpute))
   rownames(perf_combined)<-"f1"
   
  return(perf_combined)
}