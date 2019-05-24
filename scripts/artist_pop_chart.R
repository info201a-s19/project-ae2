# top artists of 2017 & 2018
library(tidyverse)
library(ggplot2)
library(plotly)
library(lintr)
library(styler)

data_2017 <- read.csv("../data/featuresdf.csv", stringsAsFactors = FALSE)
data_2018 <- read.csv("../data/top2018.csv", stringsAsFactors = FALSE)
data_combined <- read.csv("../data/2018_2017_combined.csv",
                          stringsAsFactors = F)

top_artists_2017 <- data_combined %>%
  filter(year == "2017") %>%
  group_by(artists) %>%
  summarise(num_songs = n()) %>%
  top_n(10, wt = num_songs) %>%
  mutate(year = "2017") %>%
  arrange(-num_songs)

top_artists_2018 <- data_combined %>%
  filter(year == "2018") %>%
  group_by(artists) %>%
  summarise(num_songs = n()) %>%
  top_n(10, wt = num_songs) %>%
  mutate(year = "2018") %>%
  arrange(-num_songs)

join_years <- rbind(top_artists_2017, top_artists_2018)

top_artist_overall <- join_years %>%
  filter() %>%
  group_by(artists) %>%
  summarise(num_songs = n()) %>%
  top_n(10, wt = num_songs) %>%
  arrange(-num_songs)

artist_plot_funct <- function(data_frame) {
  ggplot(data = data_frame) +
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
}

interactive_plot <- ggplotly(artist_plot_funct(join_years), tooltip = c("text"))
