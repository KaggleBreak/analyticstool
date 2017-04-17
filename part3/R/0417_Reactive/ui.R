library("shiny")

ui = fluidPage(titlePanel("censusVis"),
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
                             mainPanel(textOutput(outputId = "text1"),
                                       br(),
                                       textOutput(outputId = "text2"),
                                       br(),
                                       textOutput("num_set"),
                                       br(),
                                       textOutput("num1_1"),
                                       br(),
                                       HTML("Text with numbers"),
                                       br(),
                                       textOutput("num1_2"))))

server = function(input, output){
  output$text1 = renderText({ 
    "You have selected this"
  })
  
  output$text2 = renderText({
    "Try this."
  })
  
  output$num_set = renderText({
    input$range
  })
  
  output$num1_1 = renderText({
    input$range[1]
  })
  
  output$num1_2 = renderText({
    paste0("Number 1: ", input$range[1], " %")
  })
}


shinyApp(ui, server)