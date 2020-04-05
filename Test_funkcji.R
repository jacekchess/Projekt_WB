library(mice)
library(visdat)

## Zbiory dostępne w pakiecie mice
summary(brandsma)
str(brandsma)
summary(boys)
summary(mtcars)
summary(iris)

## Amputacja

iris_new <- iris[,-5]
iris_amp <- ampute(data = iris_new, # dane muszą być numeryczne
                  prop = 0.5, # proporcja danych do usunięcia
                  # patterns - ramka danych wskazująca gdzie usunąć
                  mech = "MCAR" # Missing Completely at Random 
                  )
summary(iris_amp$amp)

## Wizualizacja brakujących danych

mice::bwplot(iris_amp, which.pat = 1)
# lattice
md.pattern(iris_amp$amp)

# 



