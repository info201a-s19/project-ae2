library("ggplot2")
library("dplyr")
library("Hmisc")

#top2018_2017 <- read.csv("data/2018_2017_combined.csv", 
 #        stringsAsFactors = FALSE)

# I really struggled to implement color into the ggplot, even manually setting the fill to 
# blue didn't change the color of the plot at all
# I also tried changing the color through scale_fill_manual but the errors said that 
# there were multiple expressions being parsed, or it didn't like the labels in the Genre
# office hours also couldn't quite figure it out.
comparison_scatterplot <- function(element1, element2, dataframe) {
  title_label = paste("Influence of", capitalize(element1), "on", capitalize(element2))
  create_scatterplot <- ggplot(dataframe) +
    geom_point(mapping = aes_string(x = element2, y = element1), alpha = 0.3, size = 5) +
    labs(title = title_label,
             x = capitalize(paste0(element1)), y = capitalize(paste0(element2)))
#  + scale_fill_manual(values = colorBy, fill = colorBy)
  create_scatterplot
}

#comparison_scatterplot("danceability", "loudness", top2018_2017, genre)
