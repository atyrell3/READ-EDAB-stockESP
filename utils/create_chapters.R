species_names <- c(
  "ATLANTICHALIBUT",
  "ATLANTICMACKEREL",
  "ATLANTICPOLLOCK",
  "ATLANTICREDHAKE",
  "LONGFINSQUID",
  "SEASCALLOP",
  "SILVER(WHITING)HAKE",
  "WITCH(GRAY SOLE)FLOUNDER"
)

create_child <- function(species_names) {
  filename <- here::here("chapters", paste0(species_names, ".qmd"))
  file.create(filename)

  writeLines(
    text = knitr::knit_expand(
      file = here::here("utils/child_doc.qmd"),
      species = species_names
    ),
    con = filename
  )
}

purrr::map(species_names, ~ create_child(.x))
