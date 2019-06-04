library("shiny")
library("ggplot2")
library(stringr)
library(dplyr)
library(plotly)
# for violin plot

spotify_data_2017_2018 <- read.csv("data/2018_2017_combined.csv",
  stringsAsFactors = F
)
# genre needs three or more values for geom_violin plot to be generated
# combined all genres that had Country to display country genre for geom_violin plot
spotify_data_2017_2018$genre[str_detect(
  spotify_data_2017_2018$genre, "Country"
)] <- "Country"
# the folowing genres have less than three values
spotify_data_for_plot <- spotify_data_2017_2018 %>%
  filter(genre != "Rock" & genre != "Synth-pop" &
    genre != "Future-bass" & genre != "Tropical House"
  & genre != "Rap")

#For Feature Plot
feature_names <- spotify_data_2017_2018 %>%
  select(
    name, artists, danceability, energy, loudness, 
    speechiness, acousticness, instrumentalness, liveness, valence,
    tempo, genre) %>%
  `colnames<-`(c(
    "Name", "Artists", "Danceability", "Energy", "Loudness", "Speechiness", 
    "Acousticness", "Instrumentalness",
    "Liveness", "Valence", "Tempo", "Genre"
  ))
select_values <- colnames(feature_names[3:11])


violin_page <- tabPanel(
  "Genres and Audio Features",
  titlePanel("Correlations with Genre and a Particular Audio Feature"),
  sidebarLayout(
    sidebarPanel(
      # Widget to choose audio feature for y axis
      selectInput(
        inputId = "feature",
        label = "Feature",
        choices =
          colnames(spotify_data_2017_2018[, 4:ncol(spotify_data_for_plot)]),
        selected = "danceability"
      ),
      # Widget to choose genre for x axis
      selectInput(
        inputId = "genre",
        label = "Genre",
        choices = unique(spotify_data_for_plot$genre),
        selected = "Pop"
      ),
      # Widget for user to choose if want to compare audio feature
      # with second genre
      checkboxInput("add_genre",
        label = "Compare Feature with another Genre?",
        value = TRUE
      ),
      # Widget to choose second genre
      selectInput(
        inputId = "second_genre",
        label = "Genre to Compare With",
        choices = unique(spotify_data_for_plot$genre),
        selected = "Hip-Hop/Rap"
      )
    ),
    # Violin plot(s) output
    mainPanel(
      plotOutput(outputId = "violin_plot", width = "100%", height = "700px"),
      plotOutput(outputId = "violin_plot_2", width = "100%", height = "700px")
    )))

  artist_page <-  tabPanel(
      "Top 10 Artists Details",
      titlePanel("Average Features of the Top 10 Artists"),
      sidebarLayout(
        sidebarPanel(
          radioButtons("features",
                       label = ("Choose a feature"),
                       choices = c(
                         "Danceability" = "danceability",
                         "Energy" = "energy",
                         "Key" = "key",
                         "Loudness" = "loudness",
                         "Speechiness" = "speechiness",
                         "Acousticness" = "acousticness",
                         "Instrumentalness" = "instrumentalness",
                         "Liveness" = "liveness",
                         "Valence" = "valence",
                         "Tempo" = "tempo",
                         "Duration" = "duration_ms"
                       )
          )
        ),
        mainPanel(
          plotOutput("histogram")
        )
      )
    )
#Feature Analysis Panel
  x_input <- selectInput(
    "x_var",
    label = "X Variable",
    choices = select_values,
    selected = "Danceability"
  )
  
  y_input <- selectInput(
    "y_var",
    label = "Y Variable",
    choices = select_values,
    selected = "Loudness"
  )
  
  size_input <- sliderInput(
    "size",
    label = "Size of point", min = 1, max = 10, value = 2
  )
  feature_sidebar_content <- sidebarPanel(
    x_input,
    y_input,
    size_input
  )
  feature_main_content <- mainPanel(
    plotlyOutput("featuredemo")
  )
  feature_panel <- tabPanel(
    "Song Feature Analysis",
    titlePanel("Song Feature Comparison of Top 100 Songs from 2017 and 2018"),
    sidebarLayout(
      feature_sidebar_content,
      feature_main_content
    )
  )
# Define UI for application
ui <- navbarPage(
  "Spotify Statistics",
  artist_page,
  violin_page,
  feature_panel
)
