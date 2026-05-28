### FILEPATHS TO RUN LOCALLY
glorys <- here::here('data-raw/2026/glorys_2021_2026.nc')
hubert <- here::here('data-raw/2026/duPontavice_bottom_temp_1959_2021.nc')

## create EPU shapefile from strata provided
epu_shp <- terra::vect(here::here('data-raw/shapefiles', 'EPU_NOESTUARIES.shp'))

input_data <- list(
  scallop = list(
    species = "SEASCALLOP",
    strat = 'c(
   "MAB",
   "GB"
   )'
  ),
  haddock = list(
    species = "HADDOCK",
    strat = 'c(
   "GOM"
   )'
  )
)

## functions ----

# create_shp <- function(strata, orig_shp = epu_shp) {
#   shp_out <- orig_shp[orig_shp$STRATUMA %in% strata, ] |>
#     terra::aggregate()
#   # add dummy attribute so it works with edab_utils
#   shp_out$region <- "stock_area"
#
#   return(shp_out)
# }

eval_spatial <- function(species, strata_nums) {
  exp <- knitr::knit_expand(
    file = here::here("data-raw/scripts/spatial_code_template_EPU.R"),
    species = species,
    strata = strata_nums
  )

  eval(parse(text = exp))
}

### run ----

purrr::map(
  input_data,
  ~ eval_spatial(species = .x$species, strata_nums = .x$strat)
)
