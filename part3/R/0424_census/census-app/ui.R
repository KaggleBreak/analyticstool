shinyUI(fluidPage(titlePanel("censusVis"),
                  sidebarLayout(sidebarPanel(helpText("Create demographic maps with 
                                                      information from the 2010 US Census."),
                                             selectInput(inputId = "var", 
                                                         label = "Choose a variable to display",
                                                         choices = c("Percent White", "Percent Black",
                                                                     "Percent Hispanic", "Percent Asian"),
                                                         selected = "Percent White"),
                                             sliderInput(inputId = "range", 
                                                         label = "Range of interest:",
                                                         min = 0, max = 100, value = c(0, 100))),
                                mainPanel(plotOutput("map"))  # end of sidebarPanel
                                ) # end of sidebarLayout
                  ) # end of fluidPage
        ) # end of shinyUI