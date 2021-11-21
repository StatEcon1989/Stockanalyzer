#' @title The UI definition for the App
#'
#' @import shiny
ui <- fluidPage(

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
            checkboxInput("logs", label = "logs"),

            hr(),
            selectInput(inputId = "preproc", label = "Pre-processing/Smoothing",
                        choices = c("none", "first.differences", "de.trending", "EWMAx1", "EWMAx2"))
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("stockplot_all"),
            # plotOutput("select_preprocessed")
            plotly::plotlyOutput("select_preprocessed")
        )
    )
)
