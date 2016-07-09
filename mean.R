
#* @get /mean
normalMean <- function(samples=10){
  
  
  data <- rnorm(samples)
  
  write(paste0(c(samples, data, "\n", collapse = ", ")), 'logs/previous_inputs.log', append = TRUE, ncolumns = 3)
  
  mean(data)
  
  
}

