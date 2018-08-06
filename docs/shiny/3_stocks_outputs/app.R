library(shiny)
library(dplyr)
library(ggplot2)

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
      plotOutput("stock_price_plot"),
      plotOutput("stock_volume_plot")
    )
  )
)

load("stock_data.RData")

# Define server logic required to plot stocks
server <- function(input, output) {
  
  output$stock_price_plot <- renderPlot({
    
    price_data <- stock_data[[input$stock]] %>% 
      filter(
        between(index, input$dates[1], input$dates[2]),
        !grepl("Volume", series)
      )
    
    ggplot(price_data, aes(x = index, y = value, color = series)) + geom_line()
  })
  
  output$stock_volume_plot <- renderPlot({
    
    volume_data <- stock_data[[input$stock]] %>% 
      filter(
        between(index, input$dates[1], input$dates[2]),
        grepl("Volume", series)
      )
      
    ggplot(volume_data, aes(x = index, y = value, fill = series)) + geom_col()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
