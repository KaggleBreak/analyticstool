library("shiny")

# GOOG (Google), AAPL (Apple), and GS (Goldman Sachs)

shinyUI(fluidPage(titlePanel("stockVis"),
                  sidebarLayout(sidebarPanel(helpText("Select a stock to examine. 
                                                      Information will be collected from yahoo finance."),
                                             textInput(inputId = "symb",
                                                       label   = "Symbol",
                                                       value   = "SPY"),
                                             dateRangeInput(inputId = "dates",
                                                            label = "Date range",
                                                            start = "2013-01-01", 
                                                            end = as.character(Sys.Date())),
                                             br(),
                                             br(),
                                             checkboxInput(inputId = "log",
                                                           label = "Plot y axis on log scale", 
                                                           value = FALSE),
                                             checkboxInput(inputId = "adjust", 
                                                           label = "Adjust prices for inflation", 
                                                           value = FALSE)),
                                mainPanel(plotOutput("plot")))))