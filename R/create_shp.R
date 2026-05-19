#' Create shapefile from BTS strata 
#'
#' This function creates a shapefile containing the spatial information for the specified strata. It takes a character vector of strata and an original shapefile as input and returns a new shapefile with the spatial information for the specified strata.
#'
#' @param strata A character vector specifying the strata to be included in the shapefile. The strata should correspond to the STRATUMA field in the original shapefile.
#' @param orig_shp A shapefile containing the original spatial information. For example, the output of : "terra::vect(here::here('data-raw/shapefiles', 'BTS_STRATA.shp'))" 
#' @return A shapefile containing the spatial information for the specified strata, 'shp_out'
#' @export 


create_shp <- function(strata, orig_shp = shp) {
  shp_out <- orig_shp[orig_shp$STRATUMA %in% strata, ] |>
    terra::aggregate()
  # add dummy attribute so it works with edab_utils
  shp_out$region <- "stock_area"
  
  return(shp_out)
}