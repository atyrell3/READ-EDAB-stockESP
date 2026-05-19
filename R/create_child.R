#' Create child docs for stockESP Quarto book 
#'
#' This function creates a child document for species to be included in the stockESP Quarto book. 
#' It generates a new .qmd file with the appropriate structure and content based on a template located in the "utils" directory. 
#' The new file is named after the species provided as an argument.
#' Multiple species can be added by creating a character vector with all desired species names. See "utils/create_chapters.R"
#' 
#' @param species_name character or character vector. The name of the species (or list of species) to be evaluated. This should match the species names used in NESPP3 codes.
#' @export 

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
