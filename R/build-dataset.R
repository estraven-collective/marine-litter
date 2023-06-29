library(tidyverse)
library(readr)
library(ggsci)
library(sf)


# LOAD DATA

mlw_path <- here::here('data/sources/mlw-data.csv')
mlw_ds <- read_csv(mlw_path)

mlw_meta_path <- here::here('data/sources/mlw-meta.csv')
mlw_meta <- read_csv(mlw_meta_path)

italy <- read_sf('data/istat/RipGeo01012023_g_WGS84.shp') 

italy <- italy %>%
  st_transform(crs = "EPSG:4326")

marine_regions <- read_sf('data/marine_regions/MSFD_Regions_and_Subregions_LAEA_20221003.shp')

marine_regions <- marine_regions %>%
  st_transform(crs = "EPSG:4326")

marine_regions_s <- st_simplify(marine_regions, preserveTopology = FALSE, dTolerance = 0.1)


### WRANGLE DATA

mlw_it <- mlw_ds %>%
  filter(BeachCountrycode == "IT") %>%
  filter(lon_x1 > 0.1) %>%
  mutate(EventYear = substr(EventDate, 1, 4),
         EventMonth = substr(EventDate, 5, 6),
         EventDay = substr(EventDate, 7, 8)) %>%
  relocate(any_of(c("EventYear", "EventMonth", "EventDay")), .before = G1) %>%
  select(-EventDate) %>%
  rowid_to_column("ID")

mlw_it_pts <- mlw_it %>%
  st_as_sf(coords = c('lon_x1', 'lat_y1'), crs = st_crs(italy)) %>%
  select(-c(lon_x2, lat_y2, NatRef))


### EXPORT CSV

write.csv(mlw_it_pts, here::here('data/clean-data.csv'), row.names=TRUE)
