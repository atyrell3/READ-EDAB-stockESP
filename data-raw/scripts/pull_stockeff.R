source(here::here("R/stockeff.R"))

key <- read.csv(here::here("data/stockeff_lookup_table.csv")) |>
  dplyr::filter(stringr::str_detect(COMMON_NAME, "SQUID"))

pull_from_stockeff(
  url = create_url(
    itis = key$SPECIES_ITIS,
    abbrev = key$STOCK_ABBREV,
    type = key$SEX_TYPE
  ),
  out_dir = here::here("data-raw/temp"),
  filename = paste(
    key$COMMON_NAME,
    key$STOCK_ABBREV,
    key$SEX_TYPE,
    "stratified_mean_biomass.csv",
    sep = "_"
  )
)
