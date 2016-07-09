
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plumber)

fileReaderData <- reactiveFileReader(500, session = NULL, 'logs/previous_inputs.log', readLines)
system("nohup Rscript deploy.R & echo $! > save_pid.txt")

shinyServer(function(input, output) {
  
  ##kill model function
  ## kills based on PID
  observeEvent(input$kill,
               {
                 system("kill -9 `cat save_pid.txt`")
               })
  
  ## reload model function
  ## redeploy - display new PID
  observeEvent(input$redeploy,
               {
                 system("kill -9 `cat save_pid.txt`")
                 system("nohup Rscript deploy.R & echo $! > save_pid.txt")
               })

  output$fileReaderText <- renderText({
    # Read the text, and make it a consistent number of lines so
    # that the output box doesn't grow in height.
    text <- fileReaderData()
    text <- tail(text)
    text[is.na(text)] <- ""
    paste(text, collapse = '\n')
  })
  
})
