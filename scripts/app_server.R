my_server <- function(input, output) {
  spotify_data_2017_2018 <- read.csv("data/2018_2017_combined.csv", 
                                     stringsAsFactors = F)
  #Script for violin plot
  # What is the distribution for speechiness(measure of spoken words) in the most popular genre(pop)?
  # speechiness and instrumentalness are both continuous variables
  library("ggplot2") 
  library("dplyr")
  output$violin_plot <- 
    ggplot(spotify_data_2017_2018, aes(x= input$genre, y= input$feature)) +
      geom_violin() +
      labs( title = paste(input$feature, " for ", input$genre, sep = ""),
            x= input$genre,
            y = input$feature
      )
  }