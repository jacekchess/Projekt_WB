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

# folderki na poszczególne datasety zrobione ręcznie xd

save_to_file <- function(data, target, data_name) {

  # podział na treningowy i testowy 
  
  # if(dim(data)[1]==500 && dim(data)[2]==13) {
  #   data <- data[,c(-10, -11)]
  # }
  
  set.seed(13)
  
  n <- nrow(data)
  
  train_set = sample(n, 0.8 * n)
  test_set = setdiff(seq_len(n), train_set)
  data_train <- data[train_set,]
  data_test <- data[test_set,]
  
  
  ## Imputacja
  
  # Ramka uzupelniona średnią (w kolumnach numerycznych) lub modą (w innych)
  data_train_insert_mean <- data_train
  data_test_insert_mean <- data_test
  for(i in 1:ncol(data_train_insert_mean)) {
    data_train_insert_mean[is.na(data_train_insert_mean[, i]), i] <- ifelse(class(data_train_insert_mean[, i])[1] != "numeric", names(sort(table(data_train_insert_mean[, i]), decreasing = TRUE))[1], mean(data_train_insert_mean[, i], na.rm = TRUE))
  }
  for(i in 1:ncol(data_test_insert_mean)) {
    data_test_insert_mean[is.na(data_test_insert_mean[, i]), i] <- ifelse(class(data_test_insert_mean[, i])[1] != "numeric", names(sort(table(data_test_insert_mean[, i]), decreasing = TRUE))[1], mean(data_test_insert_mean[, i], na.rm = TRUE))
  }
  write.csv2(data_train_insert_mean,paste0("./files/",data_name,"/train_mean.csv"), row.names = FALSE)
  write.csv2(data_test_insert_mean,paste0("./files/",data_name,"/test_mean.csv"), row.names = FALSE)

  
  # Imputacja funkcją mice
  data_train_mice <- data_train
  data_test_mice <- data_test
  if (data_name == "dataset1018"){
    print("1018")
    imp1 <- mice(data_train_mice, m = 1, maxit = 1, nnet.MaxNWts=3000)
    data_train_mice <- mice::complete(imp1)
    imp2 <- mice(data_test_mice, m = 1, maxit = 1, nnet.MaxNWts=3000)
    data_test_mice <- mice::complete(imp2)
    print("mice")
  }
  else{
    imp1 <- mice(data_train_mice, method = "pmm", m = 1, maxit = 1, nnet.MaxNWts=3000)
    data_train_mice <- mice::complete(imp1)
    imp2 <- mice(data_test_mice, method = "pmm", m = 1, maxit = 1, nnet.MaxNWts=3000)
    data_test_mice <- mice::complete(imp2)
    print("mice")
  }
  write.csv2(data_train_mice,paste0("./files/",data_name,"/train_mice.csv"), row.names = FALSE)
  write.csv2(data_test_mice,paste0("./files/",data_name,"/test_mice.csv"), row.names = FALSE)
  
  
  # imputacja z VIM
  
  # knn - najbliżsi sąsiedzi
  data_train_vim_knn <- kNN(data_train, imp_var = FALSE) 
  data_test_vim_knn <- kNN(data_test, imp_var = FALSE) 
  # dodaje kolumny z koncówka _imp, TRUE jesli imputowane, inaczej FALSE -> imp_var FALSE to usuwa
  print("knn")
  write.csv2(data_train_vim_knn,paste0("./files/",data_name,"/train_vim_knn.csv"), row.names = FALSE)
  write.csv2(data_test_vim_knn,paste0("./files/",data_name,"/test_vim_knn.csv"), row.names = FALSE)
  
  # hotdeck - losowo wybrana wartość
  data_train_vim_hotdeck <- hotdeck(data_train, imp_var = FALSE) # podwaja, jak w knn
  data_test_vim_hotdeck <- hotdeck(data_test, imp_var = FALSE) 
  print("hotdeck")
  write.csv2(data_train_vim_hotdeck,paste0("./files/",data_name,"/train_vim_hotdeck.csv"), row.names = FALSE)
  write.csv2(data_test_vim_hotdeck,paste0("./files/",data_name,"/test_vim_hotdeck.csv"), row.names = FALSE)
  
  # softImpute + moda dla factorów
  
  factors <- unlist(lapply(data, is.factor))
  data_train_num <- softImpute::complete(data_train[!factors], softImpute(data_train[!factors], trace=TRUE, type='svd'))
  data_train_fac <- imputeMissings::impute(data_train[factors], method='median/mode')
  data_train_softImpute <- cbind(data_train_num,data_train_fac)
  
  data_test_num <- softImpute::complete(data_test[!factors], softImpute(data_test[!factors], trace=TRUE, type='svd'))
  data_test_fac <- imputeMissings::impute(data_test[factors], method='median/mode')
  data_test_softImpute <- cbind(data_test_num,data_test_fac)
  print("softImpute")
  write.csv2(data_train_softImpute,paste0("./files/",data_name,"/train_softImpute.csv"), row.names = FALSE)
  write.csv2(data_test_softImpute,paste0("./files/",data_name,"/test_softImpute.csv"), row.names = FALSE)
}

save_to_file(dataset1018,target1018,"dataset1018")
save_to_file(dataset1590,target1590,"dataset1590") # done
save_to_file(dataset188,target188,"dataset188") # done
save_to_file(dataset23381,target23381,"dataset23381") # done
save_to_file(dataset27,target27,"dataset27") # done
save_to_file(dataset29,target29,"dataset29") # done # missings
save_to_file(dataset38,target38,"dataset38") # done
save_to_file(dataset4,target4,"dataset4") # done # missings
save_to_file(dataset40536,target40536,"dataset40536") # done
save_to_file(dataset41278,target41278,"dataset41278") # done # ?
save_to_file(dataset55,target55,"dataset55") # done
save_to_file(dataset56,target56,"dataset56") # done
save_to_file(dataset6332,target6332,"dataset6332") # done # missings
save_to_file(dataset944,target944,"dataset944") # done # missings

