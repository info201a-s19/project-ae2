#Script for violin plot
# What is the distribution for speechiness(measure of spoken words) in the most popular genre(pop)?
# speechiness and instrumentalness are both continuous variables
library("ggplot2") 
library("dplyr")
chart <- function(dataset) {
  ggplot(dataset, aes(x= genre, y= speechiness)) + 
  geom_violin() +
  labs( title = "Speechiness vs Most Popular Genre in 2017 and 2018",
        x= "Genre",
        y = "Speechiness"
  )
}