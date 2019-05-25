#Script for violin plot
# What is the distribution for speechiness(measure of spoken words) in the most popular genre(pop)?
# speechiness and instrumentalness are both continuous variables
library("ggplot2") 
library("dplyr")
chart <- function(dataset) {
  dataset <- as.data.frame(dataset)
  ggplot(dataset, aes(x= genre, y= speechiness)) +
  geom_violin() +
  labs( title = "Speechiness vs Most Popular Genre",
        x= "Genre",
        y = "Speechiness"
  )
}