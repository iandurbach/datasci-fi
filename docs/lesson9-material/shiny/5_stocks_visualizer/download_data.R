# Note that this code is not part of the shiny app itself
# It was used to 'pre-download' the stock data so that the 
# app can be run without an internet connection if necessary

library(quantmod)
library(purrr)
library(broom)

start_date <- "2010-01-01"
end_date <- "2017-07-31"
stocks <- c("AAPL", "GOOG", "INTC", "FB", "MSFT", "TWTR")


stock_data <- stocks %>% 
  map(
    getSymbols, 
    from = start_date, to = end_date, 
    auto.assign = FALSE, src = "google"
  ) %>% 
  map(tidy) %>% 
  setNames(stocks)

save(stock_data, file = "stock_data.RData")
