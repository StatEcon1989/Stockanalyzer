################
## Gather Input##
################


#' @export
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
      interval = "1d", events = "history", frequency = "1d", includeAdjustedClose = "true"
    )
  )
  # check if succesful
  httr::warn_for_status(r)
  # convert response to data.frame
  text_content <- httr::content(r, type = "text", encoding = "utf8")
  df <- read.table(text = text_content, header = TRUE, sep = ",")
  df <- data.frame(Date = as.Date(df$Date), Close = as.numeric(df$Close))
  return(df)
}

#' @export
select_sample <- function(df, from, to) {
  df_selected <- df[df$Date >= from & df$Date <= to, ]
  return(df_selected)
}
