library(mice)
library(visdat)

## Zbiory dostępne w pakiecie mice
summary(brandsma)
str(brandsma)
summary(boys)
summary(mtcars)
summary(iris)

## ampute

### Przykład 1 - losowe usuwanie we wszystkich kolumnach
iris_new <- iris[,-5]
iris_amp <- ampute(data = iris_new, # dane muszą być numeryczne
                  prop = 0.5, # proporcja danych do usunięcia
                  mech = "MCAR" # Missing Completely at Random 
                  )

summary(iris_amp$amp)

### Przykład 2 - usuwanie w 2 kolumnach w tych samych wierszach
mtcars_amp1<-ampute(data=mtcars,
                   # patterns - ramka danych wskazująca gdzie usunąć
                  patterns=c(1,1,1,1,1,1,1,0,0,1,1),
                    prop = 0.5,
                    mech="MCAR")
summary(mtcars_amp1$amp)

### Przykład 3 - usuwanie w 2 kolumnach niezależnie (w różnych wierszach)?b
mtcars_amp2<-ampute(data=mtcars,
                    # patterns - ramka danych wskazująca gdzie usunąć
                    patterns=rbind(
                      c(1,1,1,1,1,1,1,0,1,1,1),
                      c(1,1,1,1,1,1,1,1,0,1,1)),
                    prop = 0.5,
                    mech="MCAR")


## Wizualizacja brakujących danych

mice::bwplot(iris_amp, which.pat = 1)
# lattice
md.pattern(iris_amp$amp)

# 



