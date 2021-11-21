#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {
    react_vals <- reactiveValues()
    output$stockplot_all <- renderPlot({
      x <- load_quote(input$symbol)
      react_vals$x <- x
      i <- ggplot2::ggplot(x, ggplot2::aes(x = Date, y = Close)) +
        ggplot2::geom_line() + ggplot2::labs(title = "Full Sample")
      i
    })
    output$stockplot_select <- renderPlot({
      y <- select_sample(react_vals$x, from = input$from, to = input$to)
      react_vals$y <- y
      i <- ggplot2::ggplot(y, ggplot2::aes(x = Date, y = Close)) +
        ggplot2::geom_line() + ggplot2::labs(title = "Sub-Sample")

    })
    # output$preprocessed <- renderPlot({
    #   z <- react_vals$y
    #   if (input$preproc == "first differences") {
    # 
    #   } else {
    #     if (input$preproc == "de-trending") {
    # 
    #     } else {
    #       #"EWMA"
    #     }
    #   }
    #   i <- ggplot2::ggplot(z, ggplot2::aes(x = Date, y = Close)) +
    #     ggplot2::geom_line() + ggplot2::labs(title = "Pre-processed Data")
    # 
    # })



  })
