

library("dplyr")
library("Hmisc")
library("ggplot2")
library(stringr)

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
  # What is the distribution for an audio feature
  # for a particular genre(e.g.pop)? How does it compare to another genre?
  #Load necessary packages

  #Data set for first violin plot based on first genre chosen
  violin_plot_data <- reactive({
    spotify_data_for_plot %>%
      filter(genre == input$genre) 
  }) 
  
  
  #Data set for second violin plot based on second genre chosen
  violin_plot_data_second_genre <- reactive({
    spotify_data_for_plot %>%
      filter(genre == input$second_genre)
  })

  #DataSet with both genres user chose
  violin_plot_data_both <- reactive ({
    rbind(violin_plot_data(), violin_plot_data_second_genre())
  })
  
  #BoxPlot for Genre(s) and Particular Feature
  output$violin_plot <- renderPlot({
    # If statement for whether user wants to compare data with another genre, and altering
    # plot if they want to
    if (input$add_genre == T) {
      dataset <- violin_plot_data_both()
      second_genre <- paste ("and ", input$second_genre)
      obs <- nrow(violin_plot_data_second_genre())
      obs_second_genre <- paste("and", obs,"for", input$second_genre, sep = " ")
    } else {
      dataset <- violin_plot_data()
      second_genre <- ""
      obs_second_genre <- ""
    }
    #Function for limits for y axis based on feature chosen
      y_limits <- function(feature,dataframe) {
        min <- min(dataframe[feature],na.rm = T)
        max <- max(dataframe[feature],na.rm = T)
        limits <- c(min, max)
      }
    ggplot(dataset, aes(x = genre)) +
      geom_boxplot(aes_string(y = eval(input$feature)), fill = "steelblue") +
      labs(title =
              paste(str_to_title(input$feature), "for", input$genre,
              second_genre, "in 2017 and 2018", sep = " "
        ),
        subtitle = paste("# Observations:", nrow(violin_plot_data()),
                         "for", input$genre,
                         obs_second_genre, sep = " "),
        x = "Genre",
        y = str_to_title(input$feature)
      ) +
      scale_y_continuous(limits = y_limits(input$feature,dataset)) +
      # Assign characteristics to titles in plot
      theme(
        plot.title = element_text(size = 26, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 14),
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 14, face = "bold"),
        aspect.ratio = 1
      )
  })
}
