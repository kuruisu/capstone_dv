function(input, output) {
  
#TAB 1
  
## plotly: neighbourhood average price for Private room
output$group1 <- renderPlotly({
  neighborhoods <-  airbnb_clean %>% 
    group_by(neighbourhood) %>% 
    filter(room_type == "Private room") %>% 
    summarise(avg = as.integer(mean(price))) %>% 
    arrange(-avg) %>% 
    head(10)%>% 
    mutate(text = paste0("Average Price Private Room : ", avg))
    
  neighborhoods_group <- ggplot(neighborhoods, aes(x=reorder(neighbourhood, avg), y=avg, text = text)) +
    geom_col(aes(fill=avg), show.legend = F) +
    coord_flip() +
    labs(title = NULL,
         y = "Average Price",
         x = NULL) +
    scale_fill_gradient(low = "#00b2ee", high = "#278afc") +
    theme(plot.title = element_text(face = "bold", size = 14, hjust = 0.04),
          axis.ticks.y = element_blank(),
          panel.background = element_rect(fill = "#ffffff"), 
          panel.grid.major.x = element_line(colour = "grey"),
          axis.line.x = element_line(color = "grey"),
          axis.text = element_text(size = 10, colour = "black"))
    
  ggplotly(neighborhoods_group, tooltip = "text")
    
  })

# plotly: neighbourhood average service fee for Private room

output$group2 <- renderPlotly({
  
  neighborhoodss <-  airbnb_clean %>% 
    group_by(neighbourhood) %>% 
    filter(room_type == "Private room") %>% 
    summarise(avg = as.integer(mean(service_fee))) %>% 
    arrange(-avg) %>% 
    head(10)%>% 
    mutate(text = paste0("Average Service Fee for Private Room : ", avg))
  
  neighborhoods_groups <- ggplot(neighborhoodss, aes(x=reorder(neighbourhood, avg), y=avg, text = text)) +
    geom_col(aes(fill=avg), show.legend = F) +
    coord_flip() +
    labs(title = NULL,
         y = "Average Service Fee",
         x = NULL) +
    scale_fill_gradient(low = "#ffff99", high = "#f1c40f") +
    theme(plot.title = element_text(face = "bold", size = 14, hjust = 0.04),
          axis.ticks.y = element_blank(),
          panel.background = element_rect(fill = "#ffffff"), 
          panel.grid.major.x = element_line(colour = "grey"),
          axis.line.x = element_line(color = "grey"),
          axis.text = element_text(size = 10, colour = "black"))
  
  ggplotly(neighborhoods_groups, tooltip = "text")
  
})

output$hexp <- renderPlotly({
  
  hexp <-  ggplot(scat_plot_data, aes(x = number_of_reviews, y = rating_per_reviews, text = text)) +
    geom_point(aes(color = neighbourhood_group, size=rating_per_reviews),alpha=0.5) +
    scale_color_manual(values = c("#9bcd9b", "#caff70","#f653a6", "#ff4040","#88e3fa")) +
    labs(title = "Airbnb Type Room in Private Room",
         y = "Rating per Reviews",
         x = "Rating")
 
  ggplotly(hexp, tooltip = "text")%>%
    layout(
      legend = list(orientation = "v",
                    y = 1, x = 0))
  
  
})


#TAB 2

# plotly reactive

output$bar_neighbourhood <- renderPlotly({
  neighbour_trend <- 
    airbnb_clean %>% 
    filter(neighbourhood_group %in% input$input_neigbour) %>% 
    group_by(construction_year) %>% 
    summarise(mean_price = mean(price)) %>% 
    mutate(label = glue("Construction year: {construction_year}
                      Average Price: {scales::comma(mean_price, accuracy = 0.01)}"))
  
  bar_neighbourhood <- 
    ggplot(data = neighbour_trend, mapping = aes(x = as.factor(construction_year), 
                                            y = mean_price, 
                                            text = label))+
    geom_line(group = 1, color = "#ff5da2") +
    geom_point() +
    scale_y_continuous(labels = scales::comma) +
    labs(title = paste("Average Price base on Construction Year", input$input_neigbour, "USD"),
         x = "Building Year Construction",
         y = "Average Price ") +
    theme_minimal() +
    theme(text = element_text(size = 8, face="bold"))
  
  ggplotly(bar_neighbourhood, tooltip = "label")
  
})


output$sliderinteractive <- renderPlotly({
  
  hist_plot <- airbnb_clean %>% 
    select(neighbourhood_group, price, neighbourhood, service_fee,room_type) %>%
    group_by(neighbourhood) %>%
    filter(price >= 100) %>%
    summarise(avg = as.integer(mean(price))) %>%
    arrange(-avg) %>%
    mutate(text = paste0("Neighbourhood Group: ", neighbourhood,"<br>",
                         "Average Price: ",avg,"<br>"))
  #"Neighbourhood: ", neighbourhood, "<br>",
  #"Room Type: ", room_type, "<br>",
  #"Room Price: ","$", price,"br",
  #"Service Fee: ","$", service_fee))
  
  hist_plots <- ggplot(hist_plot, aes(x=avg, text = text)) +
    geom_histogram( binwidth=input$bin, fill="#e342c5", color="#e9ecef", alpha=0.9) +
    labs(title ="Average Price base on Neighbourhood in New York City",
            x = "Average Price",
            y = "Frequency of Neighbourhood") +
    theme_ipsum() +
    theme(
      plot.title = element_text(size=15)
    )
  
  ggplotly(hist_plots, tooltip = "text")
  
}) 

#TAB3
output$datadisplay <- DT::renderDataTable(airbnbframe, options = list(scrollX = T))
}