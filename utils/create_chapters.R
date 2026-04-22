species_names <- c(
  "ATLANTICHALIBUT",
  "ATLANTICMACKEREL",
  "ATLANTICPOLLOCK",
  "ATLANTICREDHAKE",
  "LONGFINSQUID",
  "SEASCALLOP",
  "SILVERHAKE",
  "WITCHFLOUNDER"
)

create_child <- function(species_name) {
  filename <- here::here("chapters", paste0(species_name, ".qmd"))
  file.create(filename)

  writeLines(
    text = knitr::knit_expand(
      file = here::here("utils/child_doc.qmd"),
      species = species_name
    ),
    con = filename
  )
}

purrr::map(species_names, ~ create_child(.x))
