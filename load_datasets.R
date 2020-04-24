##############################
# PRÓBA 1
getwd()

list.files("../2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_38")

source("../2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_38/code.R")


##############################
# PRÓBA 2

# ustawienie working directory na folder datasets w repo przedmiotu
setwd("../2020L-WarsztatyBadawcze-Imputacja/datasets")
# Pamiętajcie żeby to sobie zmienić potem spowrotem, np przy użyciu:
# setwd("../../Projekt_WB")
# getwd()


#filename1<-paste(getwd(),"/openml_dataset_29/code.R", sep="")
#filename2<-"C:/Users/marty/OneDrive/Dokumenty/WarsztatyBadawcze/2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_29/code.R"
# source("C:/Users/marty/OneDrive/Dokumenty/WarsztatyBadawcze/2020L-WarsztatyBadawcze-Imputacja/datasets/openml_dataset_29/code.R")
list.files("./openml_dataset_38")

source("./openml_dataset_38/code.R")
