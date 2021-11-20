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
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "symbol", label = "Symbol",
                        value = "^GDAXI"),
            dateInput(inputId = "from", label = "Beginning of Sample",
                      max = Sys.Date()),
            dateInput(inputId = "to", label = "End of Sample",
                      max = Sys.Date())
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("stockplot")
        )
    )
))
