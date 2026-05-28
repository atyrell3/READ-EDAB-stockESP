
#### BOTTOM SALINITY

# extract var.name
glorys_salinity <- ncdf4::nc_open(here::here('data-raw/2026/glorys_salinity_1970_2026.nc')) #var.name = 'so'

# load salinity file
glorys_salinity <- here::here('data-raw/2026/glorys_salinity_1970_2026.nc')

## create stock shapefile from strata provided
shp <- terra::vect(here::here('data-raw/shapefiles', 'BTS_STRATA.shp'))

input_data <- list(
  halibut = list(
    species = "ATLANTICHALIBUT",
    strat = 'c(
    "01130",
    "01140",
    "01150",
    "01160",
    "01170",
    "01180",
    "01190",
    "01200",
    "01210",
    "01220",
    "01230",
    "01240",
    "01250",
    "01260",
    "01270",
    "01280",
    "01290",
    "01300",
    "01360",
    "01370",
    "01380",
    "01390",
    "01400"
  )'
  ),
  pollock = list(
    species = "ATLANTICPOLLOCK",
    strat = 'c(
    "01130",
    "01140",
    "01150",
    "01160",
    "01170",
    "01180",
    "01190",
    "01200",
    "01210",
    "01220",
    "01230",
    "01240",
    "01250",
    "01260",
    "01270",
    "01280",
    "01290",
    "01300",
    "01360",
    "01370",
    "01380",
    "01390",
    "01400"
  )'
  ),
  red_hake = list(
    species = "ATLANTICREDHAKE",
    strat = 'c(
    "01200",
    "01210",
    "01220",
    "01230",
    "01240",
    "01250",
    "01260",
    "01270",
    "01280",
    "01290",
    "01300",
    "01360",
    "01370",
    "01380",
    "01390",
    "01400",
    "01010",
    "01020",
    "01030",
    "01040",
    "01050",
    "01060",
    "01070",
    "01080",
    "01090",
    "01100",
    "01110",
    "01120",
    "01130",
    "01140",
    "01150",
    "01160",
    "01170",
    "01180",
    "01190",
    "01610",
    "01620",
    "01630",
    "01640",
    "01650",
    "01660",
    "01670",
    "01680",
    "01690",
    "01700",
    "01710",
    "01720",
    "01730",
    "01740",
    "01750",
    "01760"
  )'
  ),
  silver_hake = list(
    species = "SILVER(WHITING)HAKE",
    strat = 'c(
    "01200",
    "01210",
    "01220",
    "01230",
    "01240",
    "01250",
    "01260",
    "01270",
    "01280",
    "01290",
    "01300",
    "01360",
    "01370",
    "01380",
    "01390",
    "01400",
    "01010",
    "01020",
    "01030",
    "01040",
    "01050",
    "01060",
    "01070",
    "01080",
    "01090",
    "01100",
    "01110",
    "01120",
    "01130",
    "01140",
    "01150",
    "01160",
    "01170",
    "01180",
    "01190",
    "01610",
    "01620",
    "01630",
    "01640",
    "01650",
    "01660",
    "01670",
    "01680",
    "01690",
    "01700",
    "01710",
    "01720",
    "01730",
    "01740",
    "01750",
    "01760"
  )'
  ),
  # witch flounder comes with a warning message: [mask] CRS do not match. Outputs a csv with 12 monthly values.
  # removed 04 and 09 strata that correspond with state surveys
  witch_flounder = list(
    species = "WITCH(GRAY SOLE)FLOUNDER",
    strat = 'c(
    # "04010",
    # "04030",
    # "04060",
    # "04080",
    # "09250",
    # "09260",
    # "09270",
    # "09280",
    # "09290",
    # "09300",
    # "09310",
    # "09320",
    # "09330",
    # "09340",
    # "09350",
    # "09360",
    "01220",
    "01230",
    "01240",
    "01250",
    "01260",
    "01270",
    "01280",
    "01290",
    "01300",
    "01360",
    "01370",
    "01380",
    "01390",
    "01400"
  )'
  )
)

## functions ----
create_shp <- function(strata, orig_shp = shp) {
  shp_out <- orig_shp[orig_shp$STRATUMA %in% strata, ] |>
    terra::aggregate()
  # add dummy attribute so it works with edab_utils
  shp_out$region <- "stock_area"
  
  return(shp_out)
}

eval_spatial <- function(species, strata_nums) {
  exp <- knitr::knit_expand(
    file = here::here("data-raw/scripts/spatial_code_template.R"),
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

###################################################################

### MACKEREL
so_mackerel <- create_spatial_indicator(indicator_name = "bottomS", 
                                         units = "1e-3",
                                         data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                         file.time = 'annual',
                                         output.files = c(here::here('data-raw','mackerel_bottomS.nc')),
                                         shp.file = here::here('data-raw/shapefiles','EPU_NOESTUARIES.shp'),
                                         var.name = "so",
                                         area.names = c("MAB","GB","GOM","SS"),
                                         statistic = 'mean',
                                         agg.time = 'days',
                                         tz = NA,
                                         touches = TRUE,
                                         write.out = F)
write.csv(so_mackerel, here::here('data-raw/2026','mackerel_bottomS.csv'), row.names = F)

### SCALLOP
so_scallop <- create_spatial_indicator(indicator_name = "bottomS", 
                                        units = "1e-3",
                                        data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                        file.time = 'annual',
                                        output.files = c(here::here('data-raw','scallop_bottomS.nc')),
                                        shp.file = here::here('data-raw/shapefiles','EPU_NOESTUARIES.shp'),
                                        var.name = "so",
                                        area.names = c("MAB","GB"),
                                        statistic = 'mean',
                                        agg.time = 'days',
                                        tz = NA,
                                        touches = TRUE,
                                        write.out = F)
                                        
write.csv(so_scallop, here::here('data-raw/2026','scallop_bottomS.csv'), row.names = F)

### HALIBUT
so_halibut <- create_spatial_indicator(indicator_name = "bottomS", 
                                       units = "1e-3",
                                       data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                       file.time = 'annual',
                                       output.files = c(here::here('data-raw','halibut_bottomS.nc')),
                                       shp.file = here::here('data-raw/shapefiles','BTS_STRATA.shp'),
                                       var.name = "so",
                                       area.names = c("01130", "01140", "01150", "01160", "01170", "01180", "01190",
                                                      "01200", "01210", "01220", "01230", "01240", "01250", "01260",
                                                      "01270", "01280", "01290", "01300", "01360", "01370", "01380", "01390", "01400"),
                                       statistic = 'mean',
                                       agg.time = 'days',
                                       tz = NA,
                                       touches = TRUE,
                                       write.out = F)
write.csv(so_halibut, here::here('data-raw/2026','halibut_bottomS.csv'), row.names = F)

### POLLOCK
so_pollock <- create_spatial_indicator(indicator_name = "bottomS", 
                                       units = "1e-3",
                                       data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                       file.time = 'annual',
                                       output.files = c(here::here('data-raw','pollock_bottomS.nc')),
                                       shp.file = here::here('data-raw/shapefiles','BTS_STRATA.shp'),
                                       var.name = "so",
                                       area.names = c("01130", "01140", "01150", "01160", "01170", "01180", "01190",
                                                      "01200", "01210", "01220", "01230", "01240", "01250", "01260",
                                                      "01270", "01280", "01290", "01300", "01360", "01370", "01380", "01390", "01400"),
                                       statistic = 'mean',
                                       agg.time = 'days',
                                       tz = NA,
                                       touches = TRUE,
                                       write.out = F)
write.csv(so_pollock, here::here('data-raw/2026','pollock_bottomS.csv'), row.names = F)

### SILVER HAKE
so_silverhake <- create_spatial_indicator(indicator_name = "bottomS", 
                                       units = "1e-3",
                                       data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                       file.time = 'annual',
                                       output.files = c(here::here('data-raw','silverhake_bottomS.nc')),
                                       shp.file = here::here('data-raw/shapefiles','BTS_STRATA.shp'),
                                       var.name = "so",
                                       area.names = c("01200", "01210", "01220", "01230", "01240", "01250",
                                                      "01260", "01270", "01280", "01290", "01300", "01360",
                                                      "01370", "01380", "01390", "01400", "01010","01020",
                                                      "01030", "01040", "01050", "01060", "01070", "01080",
                                                      "01090", "01100", "01110", "01120", "01130", "01140",
                                                      "01150", "01160", "01170", "01180", "01190", "01610",
                                                      "01620", "01630", "01640", "01650", "01660", "01670",
                                                      "01680", "01690", "01700", "01710", "01720", "01730",
                                                      "01740", "01750", "01760"),
                                       statistic = 'mean',
                                       agg.time = 'days',
                                       tz = NA,
                                       touches = TRUE,
                                       write.out = F)

write.csv(so_silverhake, here::here('data-raw/2026','silverhake_bottomS.csv'), row.names = F)

### RED HAKE
so_redhake <- create_spatial_indicator(indicator_name = "bottomS", 
                                          units = "1e-3",
                                          data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                          file.time = 'annual',
                                          output.files = c(here::here('data-raw','redhake_bottomS.nc')),
                                          shp.file = here::here('data-raw/shapefiles','BTS_STRATA.shp'),
                                          var.name = "so",
                                          area.names = c("01200", "01210", "01220", "01230", "01240", "01250",
                                                         "01260", "01270", "01280", "01290", "01300", "01360",
                                                         "01370", "01380", "01390", "01400", "01010","01020",
                                                         "01030", "01040", "01050", "01060", "01070", "01080",
                                                         "01090", "01100", "01110", "01120", "01130", "01140",
                                                         "01150", "01160", "01170", "01180", "01190", "01610",
                                                         "01620", "01630", "01640", "01650", "01660", "01670",
                                                         "01680", "01690", "01700", "01710", "01720", "01730",
                                                         "01740", "01750", "01760"),
                                          statistic = 'mean',
                                          agg.time = 'days',
                                          tz = NA,
                                          touches = TRUE,
                                          write.out = F)

write.csv(so_redhake, here::here('data-raw/2026','redhake_bottomS.csv'), row.names = F)

### WITCH FLOUNDER
so_witch_flounder <- create_spatial_indicator(indicator_name = "bottomS", 
                                       units = "1e-3",
                                       data.in = (here::here('data-raw/2026/glorys_salinity_1970_2026.nc')),
                                       file.time = 'annual',
                                       output.files = c(here::here('data-raw','witchflounder_bottomS.nc')),
                                       shp.file = here::here('data-raw/shapefiles','EPU_NOESTUARIES.shp'),
                                       var.name = "so",
                                       area.names = c("MAB","GB","GOM","SS"),
                                       statistic = 'mean',
                                       agg.time = 'days',
                                       tz = NA,
                                       touches = TRUE,
                                       write.out = F)
write.csv(so_witch_flounder, here::here('data-raw/2026','witchflounder_bottomS.csv'), row.names = F)
