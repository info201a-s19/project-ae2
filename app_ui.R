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
      plotlyOutput("histogram")
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
  
img_link <- paste0("https://storage.googleapis.com/pr-newsroom-wp/1/2018/12/",
                    "Spotify_Wrapped_Infographic_header-copy-1920x733.jpg")

header_font <- paste0("https://fonts.googleapis.com/css?family=",
                      "Open+Sans+Condensed:300&display=swap")
  
overview <- tabPanel(
  "Overview",
  fluidPage(
    # CSS style for header font
    tags$head(
      tags$style(HTML(
        paste0("@import url('", header_font, "');")
        )
      )
    ),
    # Img from hyperlink
    img(src = img_link,
        width = "75%",
        height = "25%"),
    h1("Analyzing the Top 100 Spotify Songs of 2017 & 2018",
       style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1; 
       color: #4d3a7d;"),
    p("The music industry generated nearly $52 Billion USD globally in 2018,
      with almost 40% of that coming from the US alone",
      a(href = "https://www.statista.com/topics/1639/music/", "(source),"),
      "making it a key contributor to a world economy, along with other aspects 
      of pop culture and media entertainment, including movies, TV, gaming, etc.
      Every year, thousands of artists produce and release countless new
      songs, hoping to achieve widespread popularity. However, some artists
      just seem to top the charts year after year after year. We wondered what
      makes these tracks so notable, and thus, have created this report in
      hopes to decipher any trends or correlations that may point to a formula
      for success amidst, if one does exist."),
    p("We chose music as a topic because of its prevalence: its reach is very
      widespread and ubiquitous, with music and audio pop culture reaching every
      aspect of everyday life. People everywhere at some point in their day will
      turn on their radio, spin a vinyl, or pop in some headphones and jam out.
      Everyone has their own preferences and favorites, and often, it can be
      hard to compare different tracks, artists, or genres. This project
      attempts to breakdown the top tracks of the past two years to gain some
      more objective insight into the key audio features that define a track,
      as defined by Spotify."),
    p("The data used in this analysis comes originally from the Spotify API,
      where spotify defined and calculated all track features/attributes.
      However, we sourced the information from Nadin Tamer on Kaggle, combining
      datasets from 2017 and 2018 and adding a column for song genre. Kaggle
      sources can be found ",
      a(href = "https://www.kaggle.com/nadintamer/top-spotify-tracks-of-2018",
        "here (2017)"),
      " and ",
      a(href = "https://www.kaggle.com/nadintamer/top-spotify-tracks-of-2018",
        "here (2018)"),
      ", with more detailed attribute definitions from Spotify",
      a(href = 
          "https://developer.spotify.com/documentation/web-api/
        reference/tracks/get-audio-features/", "here."))
  )
)

conclusion <- tabPanel(
  "Takeaways",
  fluidPage(
    # CSS font
    tags$head(
      tags$style(HTML(
        paste0("@import url('", header_font, "');")
        )
      )
    ),
    # CSS font apply
    h1("Dancing to the Top",
       style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1; 
       color: #4d3a7d;"),
    p("Looking at Spotify's key audio features for the top 100 songs of 2017
      and 2018, there are two key categories that stand out: Danceability and
      Energy."),
    p("By taking the average values of each feature and computing its percentage
      of the maximum value, we can attribute a level of importance to each
      category, with values closest to the max range limit being most important.
      For example, the mean danceability of all 200 songs is 0.707, out of a 
      range of 0.0 to 1.0 with 1.0 being the maximum, leading to a 70% level of 
      importance. On the other hand, loudness has an average value of -5.67 dB,
      ranging from 0 to -60dB, giving loudness a 9.4% level of importance.
      See below for a table summarizing these values for relevant features."),
    p("By comparing these percentages, it is clear that danceability and energy
      stand out as the two most important categories, a conclusion supported by
      experience. On the radio, in stores, on TV, the most common songs are
      generally upbeat, high-energy songs that make people want to dance.
      Therefore, it should be no surprise that these two features top the charts
      in terms of importance."),
    p("Looking at the overall distribution of 
      danceability over all Spotify tracks, we find that the average value
      among the top 200 songs lies right at the peak frequency. However,
      we also find that maximizing danceability and energy is not the key
      either -- having a moderation is most common and correspondingly most
      popular."),
    img(src = "https://developer.spotify.com/assets/audio/danceability.png",
        width = "75%", height = "50%"),
    p("Similarly, we find that instrumentalness is the lowest importance.
      Popular songs are songs that people can interact with -- namely, dancing
      and singing. Songs with high instumentalness. For example, classical 
      music, which has a very high level of instrumentalness, is harder for
      people to interact with, and therefore less popular (nightclubs don't
      play Mozart and Beethoven to get the people going)."),
    p("Furthermore, this also indicates that there are other factors that
      define a successful song. There are songs with low energy and danceability
      that still manage to hit the top 100, such as James Arthur's",
      em("Say You Won't Let Go"),
      ". While the success of a song may not be able to be defined purely
      numerically and quanitatively, looking at broader, less rigidly-defined
      terms and categories may yield further insight."),
    tableOutput("importance_table"),
    
    h1("What Does Pop Even Stand For?",
       style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1; 
       color: #4d3a7d;"),
    p("It should come as no surprise that in the past few years, pop has
      has reigned supreme in the genre charts. "),
    plotOutput("genre_count"),
    p("Counting the instances of each genre over the past two years, we find
      that pop is the most common, accounting for a significant portion of the
      top charts. Following is hip-hop and rap, dance/electronic, and latin pop.
      These four genres account for over 80% of the top charts, and,
      unsurprisingly, these genres include songs with high energy, high
      danceability, and low instrumentalness. (To further explore distributions
      of audio features within genres, see the violin plots on page 3."),
    p("This indicates a current imbalance within the world of music pop culture.
      Based on this imbalance, we might conclude that for success, a track or 
      song should have not only high danceability and energy, but should also
      fall within one of these genres. For example, a country song that hits
      all other qualifications may be less likely to achieve the same success as
      a rap or pop song simply because of the lesser favorable view that pop
      culture views country music with."),
    p("This leads us closer to being able to define what makes a successful
      song -- however, it still doesn't explain the songs that yet still don't
      fit this categorization. ")
  )
)
  
# Define UI for application
ui <- navbarPage(
  "Spotify Statistics",
  overview,
  artist_page,
  violin_page,
  feature_panel,
  conclusion
)
