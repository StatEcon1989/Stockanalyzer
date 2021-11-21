#' @title The definition for the server logic of the app.
#'
#' @param input \code{list}: All objects from the UI that deliver input.
#'
#' @param output \code{list}: All objects from the UI that are used by the server
#' as output.
#'
#' @param session \code{list}: All session variables.
#'
#' @import shiny

server <- function(input, output, session) {
    react_vals <- reactiveValues()
    output$stockplot_all <- renderPlot({
      x <- load_quote(input$symbol)
      if (input$logs == TRUE) {
          x$Close <- log(x$Close)
      }
      react_vals$x <- x
      i <- ggplot2::ggplot(x, ggplot2::aes(x = Date, y = Close)) +
        ggplot2::geom_line() + ggplot2::labs(title = "Full Sample")
      i
    })
    output$select_preprocessed <- plotly::renderPlotly({
      y <- select_sample(react_vals$x, from = input$from, to = input$to)
      y <- smooth_sample(df = y, method = input$preproc)
      i <- ggplot2::ggplot(y, ggplot2::aes(Date)) +
        ggplot2::geom_line(ggplot2::aes(y = Close, color = "raw")) +
          ggplot2::geom_line(ggplot2::aes(y = Smoothed, color = "smoothed")) +
          ggplot2::labs(title = "Sub-Sample")
      plotly::ggplotly(i)

    })



  }
