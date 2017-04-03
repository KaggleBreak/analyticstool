library(shiny)
library(data.table)
library(dplyr)

sub=fread('SampleSubmission.csv') #your submission file
teams=fread('Teams.csv')

sub$Season=2016
sub$Team1=as.numeric(substring(sub$Id,6,9))
sub$Team2=as.numeric(substring(sub$Id,11,14))

sub = left_join(sub,teams,by=c('Team1'='Team_Id'))
sub = left_join(sub,teams,by=c('Team2'='Team_Id'))

sub2=sub
dim(sub)
sub$Pred
sub2$Pred=1-sub$Pred
sub2$Team_Name.x=sub$Team_Name.y
sub2$Team_Name.y=sub$Team_Name.x

sub=rbind(sub,sub2)
head(sub)
server <- function(input, output) {
  output$probability <- renderText({sub$Pred[sub$Team_Name.x == input$team1 & sub$Team_Name.y == input$team2]})
}

ui <- fluidPage(    
  sidebarLayout(      
    sidebarPanel(
      selectInput("team1", "Team1:", choices=sub$Team_Name.x),
      selectInput("team2", "Team2:", choices=sub$Team_Name.y)
    ),
    
    mainPanel(
      'Predicted probability:',
      br(),
      textOutput("probability")
    )    
    
  )
)

shinyApp(ui = ui, server = server)