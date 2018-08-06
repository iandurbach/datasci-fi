library(shiny)
library(plotly)

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Stock Visualizer"),
  
  # Sidebar with a select input for the stock,
  # date range filter, and checkbox input for 
  # whether to use a log scale
  sidebarLayout(
    sidebarPanel(
      
      helpText("Select a stock to examine."),
      
      selectInput("stock", "Stock:", 
                  choices = c("AAPL", "GOOG", "INTC", "FB", "MSFT", "TWTR"),
                  selected = "AAPL"),
      
      helpText("Filter the date range."),
      
      dateRangeInput("dates", "Date Range:",
                     start = "2017-01-01",
                     end = "2017-07-31", 
                     min = "2010-01-01",
                     max = "2017-07-31"
      ),
      
      helpText("Apply a log transformation to y-axis values."),
      
      checkboxInput("log", "Plot y-axis on log scale?", 
                    value = FALSE)
    ),
    
    # Show price and volume plots of the selected stock over the specified date range
    mainPanel(
      plotlyOutput("stock_price_plot"),
      plotlyOutput("stock_volume_plot")
    )
  )
)
