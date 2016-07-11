
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plumber)
library(ggplot2)

if (!file.exists("logs/previous_inputs.log")) {
  file.create("logs/previous_inputs.log")
}

fileReaderData <- reactiveFileReader(500, session = NULL, 'logs/previous_inputs.log', readLines)
fileReaderTimes <- reactiveFileReader(500, session = NULL, 'logs/stdoutFile.txt', readLines)
current_pid <- reactiveFileReader(1000, session = NULL, 'save_pid.txt', readLines)

pred_function <- "mean"
pred_file <- "mean.R"

system("pkill -f deploy.R")
system(paste0("nohup Rscript deploy.R ", pred_file, " & echo $! > save_pid.txt"))


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
                 system(paste0("nohup Rscript deploy.R ", pred_file, " & echo $! > save_pid.txt"))
               })
  
  observeEvent(input$test,
               {
                 if (file.exists("logs/stdoutFile.txt")) {
                   file.remove("logs/stdoutFile.txt")
                 }
                 
                 systemCall <- paste0 ("function timeout() { perl -e 'alarm shift; exec @ARGV' \"$@\"; }; ",
                                       "timeout 15 bash testReactiveFileReader.sh curl http://localhost:8001/",
                                       pred_function, " &")
                 system(systemCall)
                 #system("nohup gtimeout 15s bash testReactiveFileReader.sh &")
               })
  
  checkServerStatus <- reactiveTimer(2000)
  
  output$serverStatusText <- renderText({
    checkServerStatus()
    serverStatusCall <- paste0("curl -s \"http://localhost:8001/",
                               pred_function,"\" >/dev/null; echo $? &")
    serverStatus <- system(serverStatusCall, intern = TRUE)
    if (serverStatus == 0) {
      result <- c("Deployed")
    } else {
      result <- c("Not Deployed")
    }
    result
  })
  
  output$pid_value <- renderText({
    paste0("PID = ",current_pid())
  })
  
  output$fileReaderText <- renderText({
    # Read the text, and make it a consistent number of lines so
    # that the output box doesn't grow in height.
    text <- fileReaderData()
    text <- tail(text)
    text[is.na(text)] <- ""
    paste(text, collapse = '\n')
  })
  
  output$timeSummary <- renderPrint({
    latencies <- as.numeric(fileReaderTimes())
    summary(latencies)
  })
  
  output$timePlot <- renderPlot({
    latencies <- as.numeric(fileReaderTimes())
    ggplot2::qplot(latencies)
  })
})
