#' Download Products from StockEff with Authentication
#'
#' Authenticates against the NOAA NEFSC StockEff secure internal portal using interactively
#' supplied credentials, creates the specified output directory if it does not already exist,
#' and downloads the requested file asset.
#'
#' @details
#' This function utilizes the \code{getPass} package to securely mask password entry in
#' supported consoles. Because it establishes a secure session via an initial \code{POST}
#' request, ensure your user credentials have active access permissions to the internal
#' NOAA network endpoint.
#'
#' @param url A character string specifying the exact download URL of the StockEff product.
#' @param out_dir A character string specifying the target local directory path where the
#'   file should be saved. Created automatically if the folder does not exist
#' @param filename A character string specifying the intended name for the downloaded file
#'   (including its appropriate file extension).
#'
#' @return No return value. The function is called for its side effect of downloading
#'   a binary file to the local disk and prints a success message upon completion.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Securely pull an internal product file
#' target_url <- "https://internal.nefsc.noaa.gov/stockeff/public/products?product=12345"
#' pull_from_stockeff(
#'   url = target_url,
#'   out_dir = "data-raw",
#'   filename = "stock_assessment_2026.csv"
#' )
#' }

pull_from_stockeff <- function(url, out_dir, filename) {
  user_name <- getPass::getPass(
    msg = "Enter your username for StockEff: ",
    forcemask = FALSE
  )

  pwd <- getPass::getPass(
    msg = "Enter your password: ",
    forcemask = FALSE
  )

  login <- list(username = user_name, password = pwd, submit = "true")

  session_handle <- httr::handle("https://internal.nefsc.noaa.gov")

  login_res <- httr::POST(
    "https://internal.nefsc.noaa.gov/stockeff/public/products?product=",
    body = login,
    encode = "form",
    handle = session_handle
  )

  if (httr::status_code(login_res) >= 400) {
    stop("Login failed. Please check your credentials or network connection.")
  }

  if (!dir.exists(out_dir)) {
    dir.create(out_dir)
  }

  for (i in 1:length(url)) {
    res <- httr::GET(url[i], handle = session_handle)

    # Check if the download request actually succeeded
    if (httr::status_code(res) != 200) {
      stop("Failed to download data. Status code: ", httr::status_code(res))
    }

    bin <- httr::content(res, as = "raw")
    writeBin(bin, file.path(out_dir, filename[i]))

    message(
      "File downloaded successfully to: ",
      file.path(out_dir, filename[i])
    )
  }
}

# url <- "https://internal.nefsc.noaa.gov/stockeff/public/products?product=strat_mean&module=survey&species_itis=168559&stock_abbrev=UNIT&sex_type=NONE&mode=prod&source=all&type=csv"
# #
# pull_from_stockeff(
#   url = url,
#   out_dir = here::here("data-raw/temp"),
#   filename = "bluefish_strat_mean.csv"
# )

#' Construct StockEff Product Download URL
#'
#' Formats a query string for the NOAA NEFSC StockEff public products API endpoint.
#' The function automatically standardizes the Integrated Taxonomic Information System (ITIS)
#' code parameter by padding 6-character values with a leading zero to meet API structural constraints.
#'
#' @param itis A character string or numeric value representing the species ITIS code
#'   (e.g., \code{"164712"} or \code{164712}).
#' @param abbrev A character string specifying the stock abbreviation code (e.g., \code{"GOM"}).
#' @param type A character string specifying the sex or demographic categorization filter
#'   (e.g., \code{"all"}, \code{"F"}, or \code{"M"}).
#'
#' @return A character string containing the fully constructed, parameterized target URL
#'   configured to request a CSV output type.
#'
#' @export
#'
#' @examples
#' # Construct a standard query URL for a species with a 6-digit ITIS code
#' create_url(
#'   itis = "164712",
#'   abbrev = "GOM",
#'   type = "all"
#' )
#'
#' # The function automatically fixes short ITIS inputs
#' create_url(itis = "72345", abbrev = "GB", type = "F")

create_url <- function(itis, abbrev, type) {
  # add leading 0 if ITIS is too short
  new_itis <- ifelse(nchar(itis) == 6, itis, paste0("0", itis))
  url <- paste0(
    "https://internal.nefsc.noaa.gov/stockeff/public/products?product=strat_mean&module=survey&species_itis=",
    new_itis,
    "&stock_abbrev=",
    abbrev,
    "&sex_type=",
    type,
    "&mode=prod&source=all&type=csv"
  )
}
