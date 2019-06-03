library("shiny")
library("ggplot2")
<<<<<<< HEAD
library(stringr)
library(dplyr)
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
=======

my_ui <- fluidPage(
  navbarPage(
    "Spotify Data",
    tabPanel(
>>>>>>> f604ebd08eccfce3ab02f384a153bad04134ab13
      "Top 10 Artists Details",
      titlePanel("Average Features of the Top 10 Artists"),
      sidebarLayout(
        sidebarPanel(
          radioButtons("feature",
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
<<<<<<< HEAD





# Define UI for application
ui <- navbarPage(
  "Spotify Statistics",
  artist_page,
  violin_page
=======
  )
>>>>>>> f604ebd08eccfce3ab02f384a153bad04134ab13
)

