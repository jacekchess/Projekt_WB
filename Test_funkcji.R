library(mice)
library(visdat)

# 2 zbiory wbudowane w mice. Może warto robić przykłady na jednym z nich?
# Jak tak to którym?

summary(brandsma)
summary(boys)
summary(mtcars)
dim(iris)

iris_new <- iris[,-5]
mtcars_amputed <- ampute(iris_new, prop = 0.5, mech = "MCAR")
summary(mtcars_amputed$amp)
md.pattern(mtcars_amputed$amp)
mice::bwplot(mtcars_amputed, which.pat = 1)
