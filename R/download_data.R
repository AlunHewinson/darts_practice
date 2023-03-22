library(googledrive)
library(dplyr)
library(stringr)
library(glue)

## URL hidden from public repo
mdt_drive <- Sys.getenv("MYDARTSTRAINING_GDRIVE_URL")
mdt_files <- drive_ls("MyDartTraining")

latest_db <- mdt_files %>% 
  filter(!str_detect(name, "_practice")) %>% 
  arrange(desc(name)) %>% 
  slice(1) %>% 
  dplyr::select(name) %>% 
  unlist()
print(glue("latest_db: {latest_db}"))

drive_download(glue("MyDartTraining/{latest_db}"), overwrite = TRUE,
               path = "data/db_latest.mdt")
