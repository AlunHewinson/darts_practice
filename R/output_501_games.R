library(ggplot2)
library(dbplyr)
library(RSQLite)
library(tidyverse)

mdt_file <- "C:/Documents and Settings/alunh/Documents/repos/binary_data/darts/db_latest.mdt"

## connect to db
con <- dbConnect(drv=RSQLite::SQLite(), dbname=mdt_file)

## list all tables
tables <- dbListTables(con)

nl <- sapply(tables, function(q) {
  qq <- dbReadTable(con, q)
  if (nrow(qq) > 0) {
    cat(q)
    cat(" = ")
    cat(nrow(qq))
    cat(" rows\n")
  }
})

# Finish = 10 rows
# HalveIt = 2 rows
# HalveItRound = 19 rows
# OneOrTen = 1 rows
# Profile = 1 rows
# android_metadata = 1 rows
# aufnahme = 1893 rows
# dartTarget = 1520 rows
# playTime = 185 rows
# rtw = 73 rows
# xGame = 111 rows

aufnahme <- dbReadTable(con, "aufnahme")
# aufnahme %>% 
#   as_tibble() %>% 
#   dplyr::select(entityName) %>% 
#   unique

dartTarget <- dbReadTable(con, "dartTarget")
# dartTarget %>% 
#   dplyr::select(entityName) %>% 
#   unique

playTime <- dbReadTable(con, "playTime")
playTime

xGame <- dbReadTable(con, "xGame")
xGame %>% 
  arrange(gesamtDarts) %>% 
  dplyr::select(gesamtDarts) %>%
  unlist() %>% hist()
#plot(type="l")

xGame %>% 
  ggplot(aes(id, gesamtDarts)) +
  geom_line() + 
  geom_smooth()

##### demonstration of selection bias
## media

gameScores <- xGame %>% sample_frac(1) %>% select(gesamtDarts) %>% unlist()

allMedian <- gameScores %>% median()
randomGames <- gameScores %>% matrix(2) %>% t() %>% as.data.frame() 
randomGames %>% apply(1, min) %>% median()

library(fitdistrplus)
descdist(gameScores, discrete=FALSE, boot=500)
fitdist(gameScores, "gamma")
#fitdist(gameScores, "beta")

