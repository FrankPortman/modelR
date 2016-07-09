
#* @get /mean
normalMean <- function(samples=10){
  
  
  data <- rnorm(samples)
  ans <- mean(data)

  invisible(write(paste0(c(samples, ans), ", "), 'logs/previous_inputs.log', append = TRUE, ncolumns = 3))
  
  ans
  
}

