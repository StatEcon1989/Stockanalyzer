#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Stock Analyzer"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p(strong("Select Time-Series to Analyze")),
            br(),
            textInput(inputId = "symbol", label = "Symbol",
                        value = "^GDAXI"),
            dateInput(inputId = "from", label = "Beginning of Sample",
                      max = Sys.Date(), min = "1970-01-01",
                      value = "2000-01-01"),
            dateInput(inputId = "to", label = "End of Sample",
                      max = Sys.Date(), min = "1970-01-01"),
            
            hr(),
            selectInput(inputId = "preproc", label = "First Differences?",
                        choices = c("", "first differences", "de-trending", "EWMA"))
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("stockplot_all"),
            plotOutput("stockplot_select"),
            plotOutput("preprocessed")
        )
    )
))
