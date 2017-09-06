library(dplyr)

load("stock_data.RData")

# Define server logic required to plot stocks
server <- function(input, output) {
  
  stock_filtered_data <- reactive({
    stock_data[[input$stock]]
  })
  
  date_filtered_data <- reactive({
    stock_filtered_data() %>% 
      filter(between(index, input$dates[1], input$dates[2])) %>% 
      mutate(
        group = case_when(
          grepl("Volume", series) ~ "Volume",
                            TRUE  ~ "Price"
        )
      )
  })
  
  log_filtered_data <- reactive({
    if (input$log) {
      date_filtered_data() %>% 
        mutate(value = log(value))
    }
    else {
      date_filtered_data()
    }
  })
  
  output$stock_price_plot <- renderPlotly({
    ggplotly(ggplot(
      log_filtered_data() %>% filter(group == "Price"), 
      aes(x = index, y = value, color = series)) + 
      geom_line()
    ) %>% 
    layout(legend = list(x = 0, y = 100, orientation = "h"))
  })
  
  output$stock_volume_plot <- renderPlotly({
    ggplotly(
      ggplot(
        log_filtered_data() %>% filter(group == "Volume"), 
        aes(x = index, y = value, fill = series)
      ) + geom_col() + theme(legend.position = "none")
    )
  })

}
