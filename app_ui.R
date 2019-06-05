library("shiny")
library("ggplot2")
library(stringr)
library(dplyr)
# for violin plot
spotify_data_2017_2018 <- read.csv("data/2018_2017_combined.csv",
  stringsAsFactors = F
)
# genre needs three or more values for box plot to be generated
# combined all genres that had Country to display country genre for geom_violin plot
spotify_data_2017_2018$genre[str_detect(
  spotify_data_2017_2018$genre, "Country"
)] <- "Country"
# the folowing genres have less than three values for all features
spotify_data_for_plot <- spotify_data_2017_2018 %>%
  filter(genre != "Rock" & genre != "Synth-pop" &
    genre != "Future-bass" & genre != "Tropical House"
  & genre != "Rap")

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
          colnames(spotify_data_2017_2018[,4:15]),
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
    # Box plot output
    mainPanel(
      p("This chart allows you to analyze and understand how audio features vary from 
        genre to genre in the top songs of 2017 and 2018. You can select which audio feature you
        would like to analyze, and the particular genre you would like to view it for. In addition
        if you would like to compare two particular genres for a specific audio feature, 
        you have the option of doing so by checking the box, and choosing the second 
        genre for comparison. The chart axis limits vary with the maximum and minimum
        values of the specific audio feature chosen. This chart helps answer the question
        of what makes genres different as well as how the audio features of these genres
        have made them into the top songs of 2017 and 2018. Points in the graph indicate 
        outliersand the middle 50% lie in the box, with the upper 25% in the top half of 
        the box and the lower 25% in the lower half of the box. The top 25% remains in the
        upper whisker, and the lowest 25% remains in the lower whisker."),
      plotOutput(outputId = "violin_plot", width = "100%", height = "700px")
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

# Define UI for application
ui <- navbarPage(
  "Spotify Statistics",
  artist_page,
  violin_page
)
