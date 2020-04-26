# ##############################
# # PRÓBA 1
# getwd()
# 
# list.files("../2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_38")
# 
# source("../2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_38/code.R")
# 
# source("evaluacte_imputation.R")
# ##############################
# # PRÓBA 2
# 
# # ustawienie working directory na folder datasets w repo przedmiotu
# setwd("../2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_38")
# # Pamiętajcie żeby to sobie zmienić potem spowrotem, np przy użyciu:
# # setwd("../../Projekt_WB")
# getwd()
# 
# 
# #filename1<-paste(getwd(),"/openml_dataset_29/code.R", sep="")
# #filename2<-"C:/Users/marty/OneDrive/Dokumenty/WarsztatyBadawcze/2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_29/code.R"
# # source("C:/Users/marty/OneDrive/Dokumenty/WarsztatyBadawcze/2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_29/code.R")
# list.files("./openml_dataset_38")
# 
# source("code.R")

##################################
# ŁADOWANIE ZBIORKÓW

# PRÓBA miejmy nadzieję że ostatnia

# bawienie się z setwd() jest trochę niebezpieczne, przed wykonaniem któregokolwiek
# z poniższych fragmentów należy się upewnić, że wd to główny katalog repo i pierwszy jest wykonany jako pierwszy

# 1018
setwd("../2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_1018")
source("code.R")
dataset1018<-dataset
target1018<-target_column
target1018 %in% colnames(dataset1018) # sprawdzenie czy się ok wczytało

# 1590
setwd("../openml_dataset_1590")
source("code.R")
dataset1590<-dataset
target1590<-target_column
target1590 %in% colnames(dataset1590) # sprawdzenie czy się ok wczytało

# 188
setwd("../openml_dataset_188")
source("code.R")
dataset188<-dataset
target188<-target_column
target188 %in% colnames(dataset188) # sprawdzenie czy się ok wczytało

# 23381
setwd("../openml_dataset_23381")
source("code.R")
dataset23381<-dataset
target23381<-target_column
target23381 %in% colnames(dataset23381) # sprawdzenie czy się ok wczytało

# 27
setwd("../openml_dataset_27")
source("code.R")
dataset27<-dataset
target27<-target_column
target27 %in% colnames(dataset27) # sprawdzenie czy się ok wczytało

# 29
setwd("../openml_dataset_29")
source("code.R")
dataset29<-dataset
target29<-target_column
target29 %in% colnames(dataset29) # sprawdzenie czy się ok wczytało

# 38
setwd("../openml_dataset_38")
source("code.R")
dataset38<-dataset
target38<-target_column
target38 %in% colnames(dataset38) # sprawdzenie czy się ok wczytało

# 4
setwd("../openml_dataset_4")
source("code.R")
dataset4<-dataset
target4<-target_column
target4 %in% colnames(dataset4) # sprawdzenie czy się ok wczytało

# 40536
setwd("../openml_dataset_40536")
source("code.R")
dataset40536<-dataset
target40536<-target_column
target40536 %in% colnames(dataset40536) # sprawdzenie czy się ok wczytało

# 41278
setwd("../openml_dataset_41278")
source("code.R")
dataset41278<-dataset
target41278<-target_column
target41278 %in% colnames(dataset41278) # sprawdzenie czy się ok wczytało

# 55
setwd("../openml_dataset_55")
source("code.R")
dataset55<-dataset
target55<-target_column
target55 %in% colnames(dataset55) # sprawdzenie czy się ok wczytało

# 56
setwd("../openml_dataset_56")
source("code.R")
dataset56<-dataset
target56<-target_column
target56 %in% colnames(dataset56) # sprawdzenie czy się ok wczytało

# 6332
setwd("../openml_dataset_6332")
source("code.R")
dataset6332<-dataset
target6332<-target_column
target6332 %in% colnames(dataset6332) # sprawdzenie czy się ok wczytało

# 944
setwd("../openml_dataset_944")
source("code.R")
dataset944<-dataset
target944<-target_column
target944 %in% colnames(dataset944) # sprawdzenie czy się ok wczytało

################################
# IMPUTACJE
setwd("../../../Projekt_WB")
getwd()
source("evaluate_imputation.R")

##################################### TESTY ################################################

# numery zbiorów: 1080, 1590, 188, 23381, 27, 29, 38, 4, 40536, 41278, 55, 56, 6332, 944

###################### GIT ZBIORKI: 944, 56, 55, 38, 27, 188

evaluation_944 <- evaluate_imputation(dataset944,target944)
evaluation_56 <- evaluate_imputation(dataset56,target56) 
evaluation_55 <- evaluate_imputation(dataset55,target55)
evaluation_38 <- evaluate_imputation(dataset38,target38) # długi missForest 
evaluation_27 <- evaluate_imputation(dataset27,target27)
evaluation_188 <- evaluate_imputation(dataset188,target188)

############################### PROBLEMY: 4, 29, 1018

colnames(dataset29)[8] <- "YearsEmployed"
evaluation_29 <- evaluate_imputation(dataset29,target29) 
# działa przy ustawieniu pmm w mice, inaczej nie 

# evaluation_4 <- evaluate_imputation(dataset4,target4) 
# przy rm rows zeruje sie zbiór testowy, treningowy ma jeden wiersz 

# evaluation_1018 <- evaluate_imputation(dataset1018,target1018)
# przy rm rows zeruje sie zbiór testowy
# przy mice nie działa dla "pmm"

############################### DUŻE ZBIORKI: 41278, 6332, 40536, 1590, 1080

# na potrzeby duzych zbiorów w mice jest 1x1 , pmm i dodatkowy parametr zeby te weights sie nie wywalało 
# wykomentowane bo długo sie mielą i wywalaja sesje R czasami xd
# testowałam funkcję ręcznie na data_test dla kazdego zbioru bo dla nich jeszcze w miare sie robiło
# wiec mysle ze na train tez powinno działać xd

# evaluation_6332 <- evaluate_imputation(dataset6332,target6332) 

# ten zbiór jest zjebany bo mega duży, wywalił mi sesje 3 razy wiec moze go olejmy 
# evaluation_41278 <- evaluate_imputation(dataset41278,target41278) 

# evaluation_40536 <- evaluate_imputation(dataset40536,target40536) 

# evaluation_23381 <- evaluate_imputation(dataset23381,target23381) 

# evaluation_1590 <- evaluate_imputation(dataset1590,target1590) 


