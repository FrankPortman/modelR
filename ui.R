
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("modelR PoC"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h2("Model Status"),
      h2(textOutput("serverStatusText")),
      h3("Current deployment:", textOutput("currentPredLocation")),
      h3(textOutput("pid_value")),
      actionButton("kill", "Kill Model"),
      actionButton("redeploy", "Redeploy Model"),
      actionButton("clear", "Clear Logs"),
      actionButton("test", "Streaming Stress Test"),
      actionButton('prediction_file', 'Choose prediction function to deploy'),
      h4("Location to deploy next model: ",textOutput("predLocation"))
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Output", verbatimTextOutput("fileReaderText")), 
                  tabPanel("Latency Plot", plotOutput("timePlot")), 
                  tabPanel("Latency Summary", verbatimTextOutput("timeSummary"))
      )
    )
    
  )
))
