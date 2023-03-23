library(tidyverse)


# LOAD DATA

mlw_path <- here::here('data/mlw-data.csv')
mlw_ds <- read_csv(mlw_path)

mlw_meta_path <- here::here('data/mlw-meta.csv')
mlw_meta <- read_csv(mlw_meta_path)

olm_path <- here::here('data/olm-data.csv')
olm_ds <- read_csv(olm_path)



