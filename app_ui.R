library("shiny")
library("ggplot2")
library(stringr)
library(dplyr)
library(plotly)
library(lintr)
library(styler)
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

# For Feature Plot
feature_names <- spotify_data_2017_2018 %>%
  select(
    name, artists, danceability, energy, loudness,
    speechiness, acousticness, instrumentalness, liveness, valence,
    tempo, genre
  ) %>%
  `colnames<-`(c(
    "Name", "Artists", "Danceability", "Energy", "Loudness", "Speechiness",
    "Acousticness", "Instrumentalness",
    "Liveness", "Valence", "Tempo", "Genre"
  ))
select_values <- colnames(feature_names[3:11])

# BoxPlotPage
genre_page <- tabPanel(
  "Genres and Audio Features",
  h1("Correlations with Genre and a Particular Audio Feature",
    style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
     color: #4d3a7d;"
  ),
  sidebarLayout(
    sidebarPanel(
      # Widget to choose audio feature for y axis
      selectInput(
        inputId = "feature",
        label = "Feature",
        choices =
          colnames(spotify_data_2017_2018[, 4:15]),
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
      p("This chart allows you to analyze and understand
         how audio features vary from
        genre to genre in the top songs of 2017 and 2018.
         You can select which audio
        feature you would like to analyze, and the particular
         genre you would like to
        view it for. In addition if you would like to compare
         two particular genres for
        a specific audio feature, you have the option of doing
         so by checking the box,
        and choosing the second genre for comparison. The chart
         axis limits vary with
        the maximum and minimum values of the specific audio feature
         chosen. This chart
        helps answer the questionof what makes genres different as
         well as how the audio
        features of these genres have made them into the top songs
         of 2017 and 2018.
        Points in the graph indicate outliers and the middle 50%
         of the dataset lie in the box.
          The top 25% of the dataset remains in the upper whisker,
         and the lowest 25% of the dataset remains
        in the lower whisker. The blue point
        indicates the mean of that particular feature
        for the particular genre, with the value of the mean
        displayed next to the feature when the point
        is hovered over. Hovering over the boxplot reveals
        the values for the median and the lower
        and upper quarters, as well as the maximum
        and minimum."),
      plotlyOutput(
        outputId = "box_plot", width = "85%",
        height = "400px", inline = F
      ),
      h4(strong("Feature explanations"),
         style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
       color: #4d3a7d;"
      ),
      p(
        strong("Danceability: "), "Danceability describes how suitable a track
is for dancing based on a combination of musical elements
        including tempo, rhythm stability, beat strength, and overall
regularity.
        A value of 0.0 is least danceable and 1.0 is most danceable.",
        br(), strong("Energy: "), "Energy is a measure from 0.0 to 1.0 and
represents a perceptual measure of intensity and activity.
        Typically, energetic tracks feel fast, loud, and noisy",
        br(), strong("Loudness: "), "The overall loudness of a track in
decibels (dB).
        Loudness values are averaged across the entire track and are
        useful for comparing relative loudness of tracks",
        br(), strong("Speechiness: "), "Speechiness detects the
presence of spoken words in a track.
        The more exclusively speech-like the recording (e.g. talk show,
        audio book, poetry), the closer to 1.0 the attribute value.",
        br(), strong("Acousticness: "), "A confidence measure from
0.0 to 1.0 of whether the track is acoustic.
        1.0 represents high confidence the track is acoustic.",
        br(), strong("Instrumentalness: "), "Predicts whether a track
contains no vocals. 'Ooh' and 'aah' sounds are treated as instrumental in this
context.
        Rap or spoken word tracks are clearly 'vocal'. The closer
the instrumentalness value is to 1.0,
        the greater likelihood the track contains no vocal content. ",
        br(), strong("Liveness: "), "Detects the presence of an
audience in the recording.
        Higher liveness values represent an increased
probability that the track was performed live.
        A value above 0.8 provides strong likelihood
        that the track is live.",
        br(), strong("Valence: "), "A measure from 0.0 to 1.0
describing the musical positiveness conveyed by a track.
        Tracks with high valence sound more positive (e.g.
happy, cheerful, euphoric),
        while tracks with low valence sound more negative
        (e.g. sad, depressed, angry)",
        br(), strong("Tempo: "), "The overall estimated tempo of a track
        in beats per minute (BPM)",
        br(), strong("Duration: "), "The duration of the track in milliseconds"
      )
    )
  )
)

artist_page <- tabPanel(
  "Top 10 Artists Details",
  h1("Average Features of the Top 10 Artists",
    style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
       color: #4d3a7d;"
  ),
  sidebarLayout(
    sidebarPanel(
      radioButtons("features",
        label = ("Choose a feature"),
        choices = c(
          "Danceability" = "danceability",
          "Energy" = "energy",
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
      p("To further understand why the top artists had so many songs in the
charts,
        we decided to analyze common trends among the features for their songs
by finding
        the feature mean for the songs each top artist had. There are thirteen
artists total in the 'Top 10'
        artists because the last 9 artists all have four songs in the charts.
The histogram below compares the
        average of the features of the songs each artist had in the 2017 and
2018 charts. The type of feature
        for comparison can be chosen by the radio buttons and each color
        represents a different artist "),
      plotlyOutput("histogram"),
      h4(strong("Feature explanations"),
        style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
       color: #4d3a7d;"
      ),
      p(
        strong("Danceability: "), "Danceability describes how suitable a track
is for dancing based on a combination of musical elements
        including tempo, rhythm stability, beat strength, and overall
regularity.
        A value of 0.0 is least danceable and 1.0 is most danceable.",
        br(), strong("Energy: "), "Energy is a measure from 0.0 to 1.0 and
represents a perceptual measure of intensity and activity.
        Typically, energetic tracks feel fast, loud, and noisy",
        br(), strong("Loudness: "), "The overall loudness of a track in
decibels (dB).
        Loudness values are averaged across the entire track and are
        useful for comparing relative loudness of tracks",
        br(), strong("Speechiness: "), "Speechiness detects the
presence of spoken words in a track.
        The more exclusively speech-like the recording (e.g. talk show,
        audio book, poetry), the closer to 1.0 the attribute value.",
        br(), strong("Acousticness: "), "A confidence measure from
0.0 to 1.0 of whether the track is acoustic.
        1.0 represents high confidence the track is acoustic.",
        br(), strong("Instrumentalness: "), "Predicts whether a track
contains no vocals. 'Ooh' and 'aah' sounds are treated as instrumental in this
context.
        Rap or spoken word tracks are clearly 'vocal'. The closer
the instrumentalness value is to 1.0,
        the greater likelihood the track contains no vocal content. ",
        br(), strong("Liveness: "), "Detects the presence of an
audience in the recording.
        Higher liveness values represent an increased
probability that the track was performed live.
        A value above 0.8 provides strong likelihood
        that the track is live.",
        br(), strong("Valence: "), "A measure from 0.0 to 1.0
describing the musical positiveness conveyed by a track.
        Tracks with high valence sound more positive (e.g.
happy, cheerful, euphoric),
        while tracks with low valence sound more negative
        (e.g. sad, depressed, angry)",
        br(), strong("Tempo: "), "The overall estimated tempo of a track
        in beats per minute (BPM)",
        br(), strong("Duration: "), "The duration of the track in milliseconds"
      )
    )
  )
)

# Feature Analysis Panel
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
  p("This chart allows you to explore the relationship of features among the
    top songs from the years 2017 and 2018. You can select differing features
    to see how they relate to one another and draw insights as to what features
    make the most popular songs of the past two years. You can also set both
    axes to the same variable to explore the song artists and genres that
    correspond to the different ends of a particular feature. This answers the
    questions of what features are most common in popular songs, and what are
    common features of certain genres. Hover over chart for more details about
    point."),
  plotlyOutput("featuredemo"),
  h4(strong("Feature explanations"),
    style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
     color: #4d3a7d;"
  ),
  p(
    strong("Danceability: "), "Danceability describes how suitable a
track is for dancing based on a combination of musical elements
      including tempo, rhythm stability, beat strength, and overall regularity.
      A value of 0.0 is least danceable and 1.0 is most danceable.",
    br(), strong("Energy: "), "Energy is a measure from 0.0 to 1.0 and
represents a perceptual measure of intensity and activity.
      Typically, energetic tracks feel fast, loud, and noisy",
    br(), strong("Loudness: "), "How loud a track is in decibels, range
from -60 to 0 db.
      Loudness values are averaged across the entire track and are useful
    for comparing relative loudness of tracks",
    br(), strong("Speechiness: "), "Speechiness measure of presence of
spoken words in track, from 0 to 1
      0.66 and above is all spoken words, 0.33-0.66 is music and speech,
    and below 0.33 is music.",
    br(), strong("Acousticness: "), "A confidence measure from 0.0 to
1.0 of whether the track is acoustic.
      1.0 represents high confidence the track is acoustic.",
    br(), strong("Instrumentalness: "), "Predicts whether a track contains
no vocals. 'Ooh' and 'aah' sounds are treated as instrumental in this context.
      Rap or spoken word tracks are clearly 'vocal'. The closer the
instrumentalness value is to 1.0,
      the greater likelihood the track contains no vocal content. ",
    br(), strong("Liveness: "), "Detects the presence of an audience
in the recording.
      Higher liveness values represent an increased probability that
the track was performed live.
      A value above 0.8 provides strong likelihood that the track is live.",
    br(), strong("Valence: "), "A measure from 0.0 to 1.0 describing the
musical positiveness conveyed by a track.
      Tracks with high valence sound more positive (e.g. happy,
cheerful, euphoric),
      while tracks with low valence sound more negative (e.g. sad,
    depressed, angry)",
    br(), strong("Tempo: "), "The overall estimated tempo of a track
    in beats per minute (BPM)"
  )
)
feature_panel <- tabPanel(
  "Song Feature Analysis",
  h1("Song Feature Comparison of Top 100 Songs from 2017 and 2018",
    style = "font-family: 'Open Sans Condensed', sans-serif;
             font-weight: 1000; line-height: 1.1;
             color: #4d3a7d;"
  ),
  sidebarLayout(
    feature_sidebar_content,
    feature_main_content
  )
)

img_link <- paste0(
  "https://storage.googleapis.com/pr-newsroom-wp/1/2018/12/",
  "Spotify_Wrapped_Infographic_header-copy-1920x733.jpg"
)

header_font <- paste0(
  "https://fonts.googleapis.com/css?family=",
  "Open+Sans+Condensed:300&display=swap"
)

overview <- tabPanel(
  "Overview",
  fluidPage(
    # CSS style for header font
    tags$head(
      tags$style(HTML(
        paste0("@import url('", header_font, "');")
      ))
    ),
    # Img from hyperlink
    img(
      src = img_link,
      width = "75%",
      height = "25%"
    ),
    h1("Analyzing the Top 100 Spotify Songs of 2017 & 2018",
      style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
       color: #4d3a7d;"
    ),
    p(
      "The music industry generated nearly $52 Billion USD globally in 2018,
      with almost 40% of that coming from the US alone",
      a(href = "https://www.statista.com/topics/1639/music/", "(source),"),
      "making it a key contributor to a world economy, along with other aspects
      of pop culture and media entertainment, including movies, TV, gaming, etc.
      Every year, thousands of artists produce and release countless new
      songs, hoping to achieve widespread popularity. However, some artists
      just seem to top the charts year after year after year. We wondered what
      makes these tracks so notable, and thus, have created this report in
      hopes to decipher any trends or correlations that may point to a formula
      for success amidst, if one does exist."
    ),
    p("We chose music as a topic because of its prevalence: its reach is very
      widespread and ubiquitous, with music and audio pop culture reaching every
      aspect of everyday life. People everywhere at some point in their day will
      turn on their radio, spin a vinyl, or pop in some headphones and jam out.
      Everyone has their own preferences and favorites, and often, it can be
      hard to compare different tracks, artists, or genres. This project
      attempts to breakdown the top tracks of the past two years to gain some
      more objective insight into the key audio features that define a track,
      as defined by Spotify."),
    p(
      "The data used in this analysis comes originally from the Spotify API,
      where spotify defined and calculated all track features/attributes.
      However, we sourced the information from Nadin Tamer on Kaggle, combining
      datasets from 2017 and 2018 and adding a column for song genre. Kaggle
      sources can be found ",
      a(
        href = "https://www.kaggle.com/nadintamer/top-spotify-tracks-of-2018",
        "here (2017)"
      ),
      " and ",
      a(
        href = "https://www.kaggle.com/nadintamer/top-spotify-tracks-of-2018",
        "here (2018)"
      ),
      ", with more detailed attribute definitions from Spotify",
      a(
        href =
          "https://developer.spotify.com/documentation/web-api/
        reference/tracks/get-audio-features/", "here."
      )
    )
  )
)

conclusion <- tabPanel(
  "Takeaways",
  fluidPage(
    # CSS font
    tags$head(
      tags$style(HTML(
        paste0(
          "@import url('", header_font, "');",
          "h1 {font-family: 'Open Sans Condensed', sans-serif;
               font-weight: 1000; line-height: 1.1;
               color: #4d3a7d;}
               p {font-family: 'Tahoma';
               font-weight: 250; line-height: 1.1;
               color: #4d3a7d;"
        )
      ))
    ),
    # CSS font apply
    h1(strong("Dancing to the Top")),
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
    img(
      src = "https://developer.spotify.com/assets/audio/danceability.png",
      width = "75%", height = "50%"
    ),
    p("Similarly, we find that instrumentalness is the lowest importance.
      Popular songs are songs that people can interact with -- namely, dancing
      and singing. Songs with high instumentalness. For example, classical
      music, which has a very high level of instrumentalness, is harder for
      people to interact with, and therefore less popular (nightclubs don't
      play Mozart and Beethoven to get the people going)."),
    p(
      "Furthermore, this also indicates that there are other factors that
      define a successful song. There are songs with low energy and danceability
      that still manage to hit the top 100, such as James Arthur's",
      em("Say You Won't Let Go"),
      ". While the success of a song may not be able to be defined purely
      numerically and quanitatively, looking at broader, less rigidly-defined
      terms and categories may yield further insight."
    ),
    tableOutput("importance_table"),

    h1("Dancing = Happy? Energy = Loud?",
      style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
       color: #4d3a7d;"
    ),
    p("Based on the holistic raw data, based on our metrics, we've shown that
      high prioritization of finding the perfect balance
      of danceability and energy is a key shared trait common to many songs, not
      just in the top charts but out of all Spotify tracks. However, one may
      wonder how those tie into the other audio features. Looking at Spotify's
      definitions, at first glance, it seems logical that some features may
      interact with or conflict with others -- for example, high speechiness
      should, according to common logic, correspond to a low instrumentalness.
      Applying this to what we've found earlier may yield additional features
      or 'constraints' that supplement the appeal of danceability and energy."),
    p("Looking through all possible combinations of feature comparisons on the
      scatterplot on page 4 reveals two significant correlations that stand out
      from the rest. Many combinations show few to zero signs of a strong
      relation, yielding a seemingly random and uniform cloud of points without
      meaning -- yet, looking at our top features, we find something
      interesting: namely, in the relation between valence and danceability,
      and in loudness and energy, the graphs of which are reproduced below
      for your convenience:"),
    plotlyOutput("dancehappy"),
    p(br(), "Taking danceability as the x-variable, we can see how increasing
the
      level of danceability across the top charts leads to a strong linear
      correlation with an increase of valence, or more colloquially,
      'song happiness'. Thus, we are able to further refine our numerical
      categorization of what makes the top charts so sucessfull, by finding
      secondary relations within the feature observations -- namely, the
      importance (or at least current trend) of releasing songs that people
      can dance to in a not sad way."),
    plotlyOutput("energyloud"),
    p(br(), "Similarly, we can look at loudness as a function of energy, and
find an
      even stronger correlation: as energy goes up, so does overall track
      loudness -- a conclusion that some may find trivially obvious, but is
      demonstrated to be supported via many people's personal experience. If a
      song is a hype, lit, energetic banger, the listener is gonna want to
      crank it and jam out. No one who's ever intentionally listened to Meek
      Mill has thought 'Wow this is so energetic, I better turn down the
      volume so it's more enjoyable!'"),
    p("These correlations, however, may not truly reflect trends that define
      a successful track. It is important to keep in mind that these are only
      passive observations of an existing data frame, and that we may just be
      imposing imaginary relations between independent features and
      observations. Such is the issue with attempting to categorize a
      subjective and emotional art form such as music with quantitative,
      numerical data. The definitions may be too vague; Spotify may have an
      algorithm that defines values differently than how listeners would;
      the trends that we observe could be nothing but coincidence rather than
      some unique insight into the current state of music pop culture. That is
      why we may need to lean further from pure numbers and incorporate a
      certain level of subjectivity into this evaluation -- genres."),


    h1("What Does Pop Even Stand For?",
      style = "font-family: 'Open Sans Condensed', sans-serif;
       font-weight: 1000; line-height: 1.1;
       color: #4d3a7d;"
    ),
    p("It should come as no surprise that in the past few years, pop has
      has reigned supreme in the genre charts. "),
    plotOutput("genre_count"),
    p("Counting the instances of each genre over the past two years, we find
      that pop is the most common, accounting for a significant portion of the
      top charts. Following is hip-hop and rap, dance/electronic, and latin pop.
      These four genres account for over 80% of the top charts, and,
      unsurprisingly, these genres include songs with high energy, high
      danceability, and low instrumentalness. (To further explore distributions
      of audio features within genres, see the box plots on page 3.)"),
    p("This indicates a current imbalance within the world of music pop culture.
      Based on this imbalance, we might conclude that for success, a track or
      song should have not only high danceability and energy, but should also
      fall within one of these genres. For example, a country song that hits
      all other qualifications may be less likely to achieve the same success as
      a rap or pop song simply because of the lesser favorable view that pop
      culture views country music with."),
    p("This leads us closer to being able to define what makes a successful
      song -- however, it still doesn't explain the songs that yet still don't
      fit this categorization. And we may not ever be able to. As mentined
      above, applying such a scientific and mathematical model onto a form of
      personal human expression may never be a successful venture."),
    p("However, we've attempted to do so, albeit on a rather superficial level.
      It revealed some insights that allow us to superimpose basic number
      quantifications on the top 200 tracks of the past two years and to
      discover relations and common trends, but beyond that, we cannot strongly
      or conclusively claim our takeaways to be absolute fact, as a law of
      art and human psychology, rather than just coincidental impositions of
      trends that we create instead of discover. But hey, it's still pretty
      interesting -- perhaps we might actually be on to something.")
  )
)

# Define UI for application
ui <- navbarPage(
  "Spotify Statistics",
  overview,
  artist_page,
  genre_page,
  feature_panel,
  conclusion
)
