install.packages("tidyverse")
library("tidyverse")
library(ggplot2)
library(dplyr)
data(mpg)
mpg
print(mpg, n = 240)


filter(mpg, manufacturer == "chevrolet")
filter(mpg, manufacturer == "hyundai", cty >= 20)
filter(mpg, manufacturer == "hyundai" | cty >= 28)
filter(mpg, manufacturer == "hyundai" | cty >= 28, year==2008)

hyundai_2008 <- filter(mpg, manufacturer == "hyundai", year==2008)
hyundai_2008


slice(hyundai_2008, 1)
arrange(hyundai_2008, model, trans)

select(hyundai_2008)

iris %>% head() %>% subset(Sepal.Length >= 5.0)
install.packages("hflights")
