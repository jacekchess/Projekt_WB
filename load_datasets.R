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

# 1590
setwd("../openml_dataset_1590")
source("code.R")
dataset1590<-dataset

# 188
setwd("../openml_dataset_188")
source("code.R")
dataset188<-dataset

# 23381
setwd("../openml_dataset_23381")
source("code.R")
dataset23381<-dataset

# 27
setwd("../openml_dataset_27")
source("code.R")
dataset27<-dataset

# 29
setwd("../openml_dataset_29")
source("code.R")
dataset29<-dataset

# 38
setwd("../openml_dataset_38")
source("code.R")
dataset38<-dataset

# 4
setwd("../openml_dataset_4")
source("code.R")
dataset4<-dataset

# 40536
setwd("../openml_dataset_40536")
source("code.R")
dataset40536<-dataset

# 41278
setwd("../openml_dataset_41278")
source("code.R")
dataset41278<-dataset

# 55
setwd("../openml_dataset_55")
source("code.R")
dataset55<-dataset

# 56
setwd("../openml_dataset_56")
source("code.R")
dataset56<-dataset

# 6332
setwd("../openml_dataset_6332")
source("code.R")
dataset6332<-dataset

# 944
setwd("../openml_dataset_944")
source("code.R")
dataset944<-dataset

################################
IMPUTACJE
setwd("../../../Projekt_WB")
getwd()
source("evaluate_imputation.R")

# Wywołania jak już funkcja będzie dopracowana
# evaluate_imputation(dataset4)
