library("dplyr")
library("Hmisc")
library("ggplot2")

create_histogram <- function(dataframe, feature, artists) {
  artists_list <- dataframe %>%
    group_by(artists) %>%
    summarise(num_songs = n()) %>%
    top_n(10, wt = num_songs) %>%
    arrange(-num_songs) %>% pull(artists)
  
  songs_features <- dataframe %>% 
    filter(artists %in% artists_list) %>% 
    mutate(feature, artists) %>% 
    group_by(artists) %>% 
    summarize_(feature_mean = paste0("mean(", feature, ", na.rm = TRUE)"))
  
  ggplot(songs_features, mapping = aes(x = songs_features$artists, y = songs_features$feature_mean)) +
    labs(title = "Features of the Artists with the Most Songs on the Charts", fill = "Artist Names") +
    xlab("Top Artists") +
    ylab(capitalize(feature)) +
    geom_col(aes(fill = songs_features$artists)) +
    theme(plot.title = element_text(face="bold", 
                                    size = 16)) 
}

my_server <- function(input, output) {
  top_artists <- read.csv("data/2018_2017_combined.csv", 
                                   stringsAsFactors = F)
  output$histogram <- renderPlot(
    create_histogram(top_artists, input$feature, top_artists$artists)
  )
}

