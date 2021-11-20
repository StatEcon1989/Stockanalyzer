################
##Gather Input##
################


#' @export
load_quote <- function(symbol) {
  x <-
    quantmod::getSymbols(
      Symbols = symbol,
      from = "1900-01-01",
      to = Sys.Date(),
      warnings = FALSE,
      auto.assign = FALSE
    )
  x <- x[, endsWith(x = colnames(x), suffix = ".Close")]
  return(x)
}

#' @export
select_sample <- function(x, from, to) {
  y <-x[paste(from,to, sep="/")]
  return(y)
}
