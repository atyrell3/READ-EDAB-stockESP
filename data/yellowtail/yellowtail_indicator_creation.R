# YELLOWTAIL INDICATORS FOR DSEM WORKSHOP

## BOTTOM TEMPERATURE (ANNUAL)

# create stock shapefile
shp <- terra::vect(here::here('data-raw/shapefiles', 'SNEMA_diff.shp'))
shp$region <- "stock_area" # add dummy attribute so it works with edab_utils

# format hubert bt to SNEMA shapefile (1959-2021)
bt_hubert <- NEesp2::create_spatial_indicator(
  indicator_name = "bottomT",
  units = "degC",
  data.in = here::here('data-raw/inputs/duPontavice_bottom_temp_1959_2021.nc'),
  file.time = 'annual',
  output.files = c(here::here('data-raw', 'yellowtail_hubert_bottomT.nc')),
  shp.file = shp,
  var.name = "sea_water_temperature_at_sea_floor",
  area.names = "stock_area",
  statistic = 'mean',
  agg.time = 'days',
  tz = NA,
  touches = TRUE,
  write.out = F
)

# format glorys bt to SNEMA shapefile (2021-2026)
bt_glorys <- NEesp2::create_spatial_indicator(
  indicator_name = "bottomT",
  units = "degC",
  data.in = here::here('data-raw/inputs/glorys_2021_2026.nc'),
  file.time = 'annual',
  output.files = c(here::here('data-raw', 'yellowtail_glorys_bottomT.nc')),
  shp.file = shp,
  var.name = "bottomT",
  area.names = "stock_area",
  statistic = 'mean',
  agg.time = 'days',
  tz = NA,
  touches = TRUE,
  write.out = F
)

# create combined dataset and save daily csv
bt_data <- rbind(bt_hubert, bt_glorys)

write.csv(bt_data, here::here('data/yellowtail/bt_daily.csv'), row.names = F)

# create and save dataset of annual mean BT

annual_bt <- read.csv(here::here('data/yellowtail/bt_daily.csv')) |>
  dplyr::group_by(YEAR, INDICATOR_NAME, INDICATOR_UNITS, AREA) |>
  dplyr::summarize(
    MEAN_ANNUAL_BT = mean(DATA_VALUE, na.rm = TRUE)
  )

write.csv(annual_bt, here::here('data/yellowtail/bt_annual.csv'), row.names = F)

## BOTTOM TEMPERATURE (APR-JUN)

seasonal_bt <- read.csv(here::here('data/yellowtail/bt_daily.csv')) |>
  dplyr::filter(MONTH %in% 3:6) |>
  dplyr::group_by(YEAR, INDICATOR_UNITS, AREA) |>
  dplyr::summarize(SEASONAL_BT = mean(DATA_VALUE, na.rm = TRUE)) |>
  dplyr::mutate(INDICATOR_NAME = "bt_mar_june")

write.csv(
  seasonal_bt,
  here::here('data/yellowtail/bt_mar_june.csv'),
  row.names = F
)

## NAO Index

# Data from NOAA NCEI: https://www.ncei.noaa.gov/access/monitoring/nao/

nao_annual <- read.csv(here::here('data-raw/inputs/nao_index.csv')) |>
  dplyr::mutate(annual_nao = rowMeans(dplyr::across(Jan:Dec), na.rm = TRUE)) |>
  dplyr::rename(YEAR = Year) |>
  dplyr::mutate(INDICATOR_NAME = "annual_nao") |>
  dplyr::select(YEAR, annual_nao, INDICATOR_NAME) |>
  dplyr::arrange(YEAR) |>
  dplyr::rename(DATA_VALUE = annual_nao)

write.csv(
  nao_annual,
  here::here('data/yellowtail/nao_annual.csv'),
  row.names = F
)

## AMO Index

# Data from NOAA PSL: https://psl.noaa.gov/data/timeseries/AMO/
# Using AMO smoothed, short (1948 to Jan 2023)

amo_annual <- read.csv(here::here('data-raw/inputs/amo_index.csv')) |>
  dplyr::group_by(Year) |>
  dplyr::summarize(
    DATA_VALUE = mean(SSTA, na.rm = TRUE)
  ) |>
  dplyr::mutate(INDICATOR_NAME = "annual_amo")

write.csv(
  amo_annual,
  here::here('data/yellowtail/amo_annual.csv'),
  row.names = F
)

## Cold Pool Index

# Filtered to cold pool index only (removing persistence and spatial extent)
cpi <- ecodata::cold_pool |>
  dplyr::filter(Var == "cold_pool_index")

write.csv(cpi, here::here('data/yellowtail/cold_pool_index.csv'), row.names = F)

## Gulf Stream Index

# Annual (filtered only to gsi and removed western gsi)

gsi <- ecodata::gsi |>
  dplyr::select(-X) |>
  tidyr::separate(
    Time,
    into = c("Year", "Month"),
    sep = "\\.",
    convert = TRUE
  ) |>
  dplyr::filter(Var == "gulf stream index") |>
  dplyr::group_by(Year, Var) |>
  dplyr::summarize(
    annual_gsi = mean(Value, na.rm = TRUE)
  )

write.csv(gsi, here::here('data/yellowtail/gsi_annual.csv'), row.names = F)

# Spring (Jan - June)

gsi_spring <- ecodata::gsi |>
  dplyr::select(-X) |>
  tidyr::separate(
    Time,
    into = c("Year", "Month"),
    sep = "\\.",
    convert = TRUE
  ) |>
  dplyr::filter(Var == "gulf stream index") |>
  dplyr::filter(Month %in% 1:6) |>
  dplyr::group_by(Year, Var) |>
  dplyr::summarize(
    spring_gsi = mean(Value, na.rm = TRUE)
  )

write.csv(
  gsi_spring,
  here::here('data/yellowtail/gsi_spring.csv'),
  row.names = F
)
