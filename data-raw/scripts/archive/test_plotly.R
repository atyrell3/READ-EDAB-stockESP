url1 <- here::here("data-raw/2026/ATLANTICHALIBUT_hubert_bottomT.csv")
url2 <- here::here("data-raw/2026/ATLANTICHALIBUT_glorys_bottomT.csv")

bt_data <- read.csv(url1) |>
  dplyr::bind_rows(read.csv(url2)) |>
  dplyr::group_by(AREA, MONTH, YEAR, INDICATOR_NAME, INDICATOR_UNITS) |>
  dplyr::summarise(DATA_VALUE = mean(DATA_VALUE, na.rm = TRUE), .groups = "drop") |>
  dplyr::mutate(INDICATOR_NAME = "monthly_bottomT")

bt_data |>
  dplyr::filter(MONTH == 1) |>
  NEesp2::plt_indicator(
    ar = 1/4,
    include_trends = TRUE
  ) |>
# +
#   ggplot2::ggtitle(paste0("Monthly bottom temperature in stock area - ", month.abb[1])) 
  plotly::ggplotly()
