#Script for violin plot
# What is the distribution for speechiness(measure of spoken words) in the most popular genre(pop)?
# speechiness and instrumentalness are both continuous variables
library("ggplot2") 
library("dplyr")

# chart <- function(dataset) {
#   dataset <- as.data.frame(dataset)
#   ggplot(dataset, aes(x= genre, y= speechiness)) +
#   geom_violin() +
#   labs( title = "Speechiness vs Most Popular Genre",
#         x= "Genre",
#         y = "Speechiness"
#   )x
# }

library("ggplot2") 
library("dplyr")
spotify_data_2017_2018 <- read.csv("data/2018_2017_combined.csv", 
                                   stringsAsFactors = F)
violin_plot_data <- spotify_data_2017_2018 %>%
  filter(genre == "Pop")

ggplot(data = violin_plot_data, aes (x= genre, 
                                     y= danceability))+
  geom_violin() +
  labs( title = paste("danceability", " for ",  sep = ""),
        x= "genre",
        y = "danceability")