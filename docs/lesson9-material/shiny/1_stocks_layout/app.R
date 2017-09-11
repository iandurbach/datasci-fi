library(shiny)

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
      
      helpText("Filter the date range."),
      
      helpText("Apply a log transformation to the price data.")
  
    ),
      
    # Show price and volume plots of the selected stock over the specified date range
    mainPanel()
  )
)

# Define server logic required to plot stocks
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)
