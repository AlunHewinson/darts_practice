library(dbplyr)
library(RSQLite)
library(readr)

mdt_file <- "C:/Documents and Settings/alunh/Documents/repos/binary_data/darts/db_latest.mdt"

## connect to db
con <- dbConnect(drv=RSQLite::SQLite(), dbname=mdt_file)

## list all tables
tables <- dbListTables(con)

game_501 <- dbReadTable(con, "aufnahme")

unfinished_or_lost <- game_501 %>% 
  group_by(entityId) %>% 
  filter(round == max(round)) %>% 
  filter(beginnScore != score) %>% 
  select(entityId) %>% ungroup()

completed_games <- game_501 %>% 
  anti_join(unfinished_or_lost) %>% 
  select(-entityName, -profileId)

write_csv(completed_games, file = "data/completed_501_games.csv")
