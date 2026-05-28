# convert longitude from 0-360 to -180-180 for the OISST data
sst_converted <- EDABUtilities::convert_longitude(data = here::here('data-raw/2026','oisst_monthly_1981_2026.nc'))


## create EPU shapefile from strata provided
epu_shp <- terra::vect(here::here('data-raw/shapefiles', 'EPU_NOESTUARIES.shp'))

input_data <- list(
  mackerel = list(
    species = "ATLANTICMACKEREL",
    strat = c("MAB", "GB", "SS", "GOM")  # Removed single quotes
 )
)

## functions ----
eval_spatial <- function(species, strata_nums) {
  strata_string <- paste0('c(', paste0('"', strata_nums, '"', collapse = ", "), ')')
  exp <- knitr::knit_expand(
    file = here::here("data-raw/scripts/spatial_code_template_EPU.R"),
    species = species,
    strata = strata_string 
  )
  eval(parse(text = exp))
}

### run ----

purrr::map(
  input_data,
  ~ eval_spatial(species = .x$species, strata_nums = .x$strat)
)


######################################
### MACKEREL

sst_converted <- EDABUtilities::convert_longitude(data = here::here('data-raw/2026','oisst_monthly_1981_2026.nc'))

sst_mackerel <- create_spatial_indicator(indicator_name = "sst", 
                                       units = "degC",
                                       data.in = sst_converted,
                                       file.time = 'annual',
                                       output.files = c(here::here('data-raw','mackerel_sst.nc')),
                                       shp.file = here::here('data-raw/shapefiles','EPU_NOESTUARIES.shp'),
                                       var.name = "sst",
                                       area.names = c("MAB","GB","GOM","SS"),
                                       statistic = 'mean',
                                       agg.time = 'days',
                                       tz = NA,
                                       touches = TRUE,
                                       write.out = F)
write.csv(sst_mackerel, here::here('data-raw/2026','mackerel_sst.csv'), row.names = F)

