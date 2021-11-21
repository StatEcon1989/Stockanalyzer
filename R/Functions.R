##################
## Gather Input ##
##################


#' @title Requesting historic information from Yahoo-Finance
#'
#' @description Acesses the API of Yahoo Finance to gather close prices of the
#' selected stock symbol
#'
#' @param symbol \code{character}: The Symbol for a specific asset such as stocks,
#' FX rates, etc.
#'
load_quote <- function(symbol = "^GDAXI") {
  # Yahoo Basedate
  from <- as.numeric(as.POSIXct("1970-01-01"))
  # today
  to <- as.numeric(as.POSIXct(Sys.Date())) - from
  # The base_url of the Yahoo Finance API
  base_url <- paste0("https://query1.finance.yahoo.com/v7/finance/download/", symbol)

  # Get daily, historical information
  r <- httr::GET(base_url,
                 httr::add_headers(connection = "close"),
                 query = list(period1 = from, period2 = to,
                              interval = "1d", events = "history", frequency = "1d",
                              includeAdjustedClose = "true"
                 )
  )
  # check if succesful
  httr::warn_for_status(r)
  # convert response to data.frame
  text_content <- httr::content(r, type = "text", encoding = "utf8")
  df <- utils::read.table(text = text_content, header = TRUE, sep = ",")
  df <- data.frame(Date = as.Date(df$Date), Close = as.numeric(df$Close))
  df <- df[!is.na(df$Close), ]
  return(df)
}

#' @title Take a sub-sample
#'
#' @description uses the output from [load_quote] and reduces the full sample to
#' a sub-sample over the desired timespan.
#'
#' @param df \code{data.frame}:
#'
#' @param from \code{character}: Starting date in the format "YYYY-MM-DD".
#'
#' @param to \code{character}: End date in the format "YYYY-MM-DD".
#'
select_sample <- function(df, from, to) {
  df_selected <- df[df$Date >= from & df$Date <= to, ]
  return(df_selected)
}

#' @title Smoothing
#'
#' @description Uses the output from [select_sample] or [load_quote] and creates
#' an additional column, containing the smoothed/differenced time-series.
#'
#' @param method \code{character}: Various smoothing/detrending/differencing
#' operations are available.
#'
#' @param df \code{data.frame}:
smooth_sample <- function(df, method) {
  smoother <- switch(method,
                     none = function(x) x,
                     first.differences = function(x) c(NA, x[1:(length(x) - 1)]),
                     de.trending = function(x) stats::fitted(stats::lm(x ~ seq_along(x))),
                     EWMAx1 = function(x) c(NA, stats::fitted(stats::HoltWinters(x = x, beta = FALSE, gamma = FALSE))[, "xhat"]),
                     EWMAx2 = function(x) c(NA, NA, stats::fitted(stats::HoltWinters(x = x, gamma = FALSE))[, "xhat"]),
  )
  df$Smoothed <- smoother(df$Close)
  return(df)
}

#' @title Shiny App
#'
#' @description Shiny App for analyzing Assets listed on Yahoo Finance.
#'
#' @export
app <- function() {
  shiny::shinyApp(ui = ui, server = server)
}
