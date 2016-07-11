library(plumber)
args<-commandArgs(TRUE)
r <- plumb(args[1])  # Where 'myfile' is the location of the file shown above
r$run(port=8001)
