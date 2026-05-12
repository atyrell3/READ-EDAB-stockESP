#' Evaluate spatial data for a given species and BTS strata 
#'
#' This function evaluates the spatial data for a specified species across a set of BTS strata. It uses a template R script that contains the code for processing the spatial data, and fills in the species name and strata numbers to generate the appropriate code for evaluation.
#'
#' @param species character. The name of the species to be evaluated. This should match the species names used in NESPP3 codes.
#' @param strata_nums A character vector or list of BTS strata to be evaluated for the given species. 
#' @export 



eval_spatial <- function(species, strata_nums) {
  exp <- knitr::knit_expand(
    file = here::here("data-raw/scripts/spatial_code_template.R"),
    species = species,
    strata = strata_nums
  )
  
  eval(parse(text = exp))
}