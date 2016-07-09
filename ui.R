
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
      h2("Deployed"),
      h3("PID = 12345"),
      actionButton("kill", "Kill Model"),
      actionButton("redeploy", "Redeploy Model"),
      actionButton("clear", "Clear Logs")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("fileReaderText")
    )
  )
))
