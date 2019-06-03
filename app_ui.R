library("shiny")
library("ggplot2")

my_ui <- fluidPage(
  navbarPage(
    "Spotify Data",
    tabPanel(
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
  )
)

