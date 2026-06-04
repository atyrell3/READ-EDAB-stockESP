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

  httr::POST(
    "https://internal.nefsc.noaa.gov/stockeff/public/products?product=",
    body = login,
    encode = "form"
  )

  if (!dir.exists(out_dir)) {
    dir.create(out_dir)
  }

  res <- httr::GET(url)
  bin <- httr::content(res, as = "raw")
  writeBin(bin, file.path(out_dir, filename))

  message("File downloaded successfully to: ", file.path(out_dir, filename))
}

# url <- "https://internal.nefsc.noaa.gov/stockeff/public/products?product=strat_mean&module=survey&species_itis=168559&stock_abbrev=UNIT&sex_type=NONE&mode=prod&source=all&type=csv"
#
# pull_from_stockeff(
#   url = url,
#   out_dir = here::here("data-raw/temp"),
#   filename = "bluefish_strat_mean.csv"
# )
