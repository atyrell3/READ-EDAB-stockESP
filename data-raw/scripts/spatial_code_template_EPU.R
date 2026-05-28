# strata ----
species_shp <- epu_shp


# bt <- NEesp2::create_spatial_indicator(
#   indicator_name = "bottomT",
#   units = "degC",
#   data.in = hubert,
#   file.time = 'annual',
#   output.files = c(here::here('data-raw', '{{ species }}_bottomT.nc')),
#   shp.file = species_shp,
#   var.name = "sea_water_temperature_at_sea_floor",
#   area.names = {{ strata }},
#   statistic = 'mean',
#   agg.time = 'days',
#   tz = NA,
#   touches = TRUE,
#   write.out = F
# )
# 
# write.csv(
#   bt,
#   here::here('data-raw/2026', '{{ species }}_hubert_bottomT.csv'),
#   row.names = FALSE
# )
# 
# # glorys ----
# glorys_species <- NEesp2::create_spatial_indicator(
#   indicator_name = "bottomT",
#   units = "degC",
#   data.in = glorys,
#   file.time = 'annual',
#   output.files = c(here::here('data-raw', '{{ species }}_glorys.nc')),
#   shp.file = species_shp,
#   var.name = "bottomT",
#   area.names = {{ strata }},
#   statistic = 'mean',
#   agg.time = 'days',
#   tz = NA,
#   touches = TRUE,
#   write.out = F
# )
# write.csv(
#   glorys_species,
#   here::here('data-raw/2026', '{{ species }}_glorys_bottomT.csv'),
#   row.names = FALSE
# )

# # glorys bottom salinity ----
# glorys_species_sal <- NEesp2::create_spatial_indicator(
#   indicator_name = "bottomS",
#   units = "1e-3",
#   data.in = glorys_salinity,
#   file.time = 'annual',
#   output.files = c(here::here('data-raw', '{{ species }}_glorys_bottomS.nc')),
#   shp.file = species_shp,
#   var.name = "so",
#   area.names = {{ strata }},
#   statistic = 'mean',
#   agg.time = 'days',
#   tz = NA,
#   touches = TRUE,
#   write.out = F
# )
# 
# write.csv(
#   glorys_species_sal,
#   here::here('data-raw/2026', '{{ species }}_glorys_bottomS.csv'),
#   row.names = FALSE
# )

# chlorophyll ----

occci_chl <- NEesp2::create_spatial_indicator(
  indicator_name = "chlor_a",
  units = "m^-3",
  data.in = chl,
  file.time = 'annual',
  output.files = c(here::here('data-raw', '{{ species }}_chl.nc')),
  shp.file = species_shp,
  var.name = "chlor_a",
  area.names ={{ strata }},
  statistic = 'mean',
  agg.time = 'days',
  tz = NA,
  touches = TRUE,
  write.out = F
)

write.csv(
  occci_chl,
  here::here('data-raw/2026', '{{ species }}_chl.csv'),
  row.names = FALSE
)

# # SST ----
# sst <- NEesp2::create_spatial_indicator(indicator_name = "sst",
#                                          units = "degC",
#                                          data.in = sst_converted,
#                                          file.time = 'annual',
#                                          output.files = c(here::here('data-raw','{{ species }}_sst.nc')),
#                                          shp.file = species_shp,
#                                          var.name = "sst",
#                                          area.names = {{ strata }},
#                                          statistic = 'mean',
#                                          agg.time = 'days',
#                                          tz = NA,
#                                          touches = TRUE,
#                                          write.out = F)
# 
# write.csv(
#   sst,
#   here::here('data-raw/2026','{{ species}}_sst.csv'),
#   row.names = FALSE
#   )


