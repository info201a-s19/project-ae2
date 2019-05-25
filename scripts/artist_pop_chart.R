# top artists of 2017 & 2018
library(tidyverse)
library(ggplot2)
library(plotly)
library(lintr)
library(styler)


artist_plot_funct <- function(data_frame) {
  data_frame <- as.data.frame(data_frame)
  reg_chart <- ggplot(data = data_frame) +
    geom_col(
      mapping = aes(x = artists, y = num_songs, fill = year, text = paste0(
        "Artist ",
        artists, "\nSong Number: ", num_songs
      ))
    ) +
    ggtitle("Top Artists of 2017 and 2018") +
    labs(y = "Number of Songs", x = "Artist") +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(hjust = 0.5)
    ) +
    scale_fill_discrete(name = "Year")
  ggplotly(reg_chart, tooltip = c("text"))
}


