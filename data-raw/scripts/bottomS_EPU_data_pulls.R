# extract var.name
glorys_salinity <- ncdf4::nc_open(here::here('data-raw/2026/glorys_salinity_1970_2026.nc')) #var.name = 'so'

# load salinity file
glorys_salinity <- here::here('data-raw/2026/glorys_salinity_1970_2026.nc')

## create EPU shapefile from strata provided
epu_shp <- terra::vect(here::here('data-raw/shapefiles', 'EPU_NOESTUARIES.shp'))

input_data <- list(
  scallop = list(
    species = "SEASCALLOP",
    strat = c("MAB", "GB")  # Removed single quotes
  ),
  haddock = list(
    species = "HADDOCK",
    strat = c("GOM")        # Removed single quotes
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
