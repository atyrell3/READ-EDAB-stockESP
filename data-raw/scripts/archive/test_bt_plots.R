#this works but only for one species
hubert <- here::here("data-raw/2026/silverhake_hubert_bottomT.csv")
glorys <- here::here("data-raw/2026/SILVERHAKE_glorys_bottomT.csv")

# test reading in using {{ species }}
sp_name <- {{ species }}
here::here('data-raw/2026', paste0(stringr::str_to_upper(sp_name), '_hubert_bottomT.csv'))

hubert <- here::here('data-raw/2026', paste0(stringr::str_to_upper("{{ species }}"), '_hubert_bottomT.csv'))
glorys <- here::here('data-raw/2026', paste0(stringr::str_to_upper("{{ species }}"), '_glorys_bottomT.csv'))

# or

hubert <- here::here('data-raw/2026/{{ species}}_hubert_bottomT.csv')
glorys <- here::here('data-raw/2026/{{ species}}_glorys_bottomT.csv')

# from child_doc.qmd
bt_data <- read.csv(hubert) |>
  dplyr::bind_rows(read.csv(glorys)) |>
  dplyr::group_by(AREA, MONTH, YEAR, INDICATOR_NAME, INDICATOR_UNITS) |>
  dplyr::summarise(DATA_VALUE = mean(DATA_VALUE, na.rm = TRUE), .groups = "drop") |>
  dplyr::mutate(INDICATOR_NAME = "monthly_bottomT")

for(i in 1:12) {
  print(
    bt_data |>
      dplyr::filter(MONTH == i) |>
      NEesp2::plt_indicator(
        ar = 1/4,
        include_trends = TRUE
      ) +
      ggplot2::ggtitle(paste0("Monthly bottom temperature in stock area - ", month.abb[i]))
  )
}
