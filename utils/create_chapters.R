species_names <- c(
  "American lobster",
  "Atlantic cod",
  "Atlantic croaker",
  "Atlantic halibut",
  "Atlantic herring",
  "Atlantic mackerel",
  "Atlantic menhaden",
  "Atlantic sea scallop",
  "Atlantic surfclam",
  "Atlantic wolffish",
  "Black sea bass",
  "Blue crab",
  "Bluefin tuna",
  "Bluefish",
  "Blueline tilefish",
  "Butterfish",
  "Chub mackerel",
  "Cobia",
  "Eastern oyster",
  "Golden tilefish",
  "Haddock",
  "Longfin squid",
  "Monkfish",
  "Northern Quahog",
  "Ocean pout",
  "Ocean quahog",
  "Pollock",
  "Red drum",
  "Scup",
  "Shortfin squid",
  "Smooth dogfish",
  "Softshell clam",
  "Spanish mackerel",
  "Spiny dogfish",
  "Striped bass",
  "Summer flounder",
  "Tautog",
  "White hake",
  "Windowpane flounder",
  "Winter flounder",
  "Witch flounder",
  "Yellowtail flounder"
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
