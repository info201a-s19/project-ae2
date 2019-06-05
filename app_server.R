library("dplyr")
library("Hmisc")
library("ggplot2")
library(stringr)
library(shiny)
library(plotly)

create_histogram <- function(dataframe, feature, artists) {
  artists_list <- dataframe %>%
    group_by(artists) %>%
    summarise(num_songs = n()) %>%
    top_n(10, wt = num_songs) %>%
    arrange(-num_songs) %>%
    pull(artists)

  songs_features <- dataframe %>%
    filter(artists %in% artists_list) %>%
    mutate(feature, artists) %>%
    group_by(artists) %>%
    summarize_(feature_mean = paste0("mean(", feature, ", na.rm = TRUE)"))

  ggplotly(ggplot(songs_features, mapping = aes(
    x = songs_features$artists,
    y = songs_features$feature_mean
  )) +
    labs(
      title = "Features of the Artists with the Most Songs on the Charts",
      fill = "Artist Names"
    ) +
    xlab("Top Artists") +
    ylab(capitalize(feature)) +
    geom_col(aes(
      fill = songs_features$artists,
      text = paste0(
        "Artist: ", songs_features$artists,
        "\nMean: ", round(songs_features$feature_mean, digits = 2)
      )
    )) +
    theme(
      plot.title = element_text(
        face = "bold",
        size = 16
      ),
      axis.text.x = element_text(angle = 45, hjust = 1)
    ), tooltip = "text")
}

server <- function(input, output) {
  top_artists <- read.csv("data/2018_2017_combined.csv",
    stringsAsFactors = F
  )
  output$histogram <- renderPlotly(
    create_histogram(top_artists, input$features, top_artists$artists)
  )
  # What is the distribution for an audio feature
  # for a particular genre(e.g.pop)? How does it compare to another genre?

  # Data set for first box plot based on first genre chosen
  violin_plot_data <- reactive({
    spotify_data_for_plot %>%
      filter(genre == input$genre)
  })
  # Data set for second box plot based on second genre chosen
  violin_plot_data_second_genre <- reactive({
    spotify_data_for_plot %>%
      filter(genre == input$second_genre)
  })

  # DataSet with both genres user chose
  violin_plot_data_both <- reactive({
    rbind(violin_plot_data(), violin_plot_data_second_genre())
  })

  # BoxPlot for Genre(s) and Particular Feature
  output$box_plot <- renderPlotly({
    # If statement for whether user wants to compare data with another genre, and altering
    # plot if they want to
    if (input$add_genre == T) {
      dataset <- violin_plot_data_both() 
      second_genre <- paste("and ", input$second_genre)
      obs <- nrow(violin_plot_data_second_genre())
      obs_second_genre <- paste("and", obs, "for", input$second_genre, sep = " ")
    } else {
      dataset <- violin_plot_data()
      second_genre <- ""
      obs_second_genre <- ""
    }
    # Function for limits for y axis based on feature chosen
    y_limits <- function(feature, dataframe) {
      min <- min(dataframe[feature], na.rm = T)
      max <- max(dataframe[feature], na.rm = T)
      limits <- c(min, max)
    }
    ggplotly(ggplot(dataset, aes(x = genre)) +
      geom_boxplot(aes_string(y = eval(input$feature)), fill = "steelblue",
                  outlier.size =3, outlier.colour = "purple") +
        stat_summary(mapping =aes_string(y=eval(input$feature)), 
                     fun.y = mean, geom = "point", colour = "red",na.rm =T) +
      labs(
        title =
          paste(str_to_title(input$feature), "for", input$genre,
             second_genre,
            sep = " "
          ),
        x = "Genre",
        y = str_to_title(input$feature)
      ) +
      scale_y_continuous(limits = y_limits(input$feature, dataset)) +
      # Assign characteristics to titles in plot
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        plot.subtitle = element_text(size = 10),
        axis.title = element_text(size = 10, face = "bold"),
        axis.text = element_text(size = 10)
      ), animate = F)
  })

  # Scatterplot of Song Features
  output$featuredemo <- renderPlotly({
    title <- paste0(
      "Song ", input$x_var,
      " v.s. ", "Song ", input$y_var
    )

    demo_plot <- ggplotly(ggplot(feature_names) +
      geom_point(
        mapping = aes_string(
          x = input$x_var,
          y = input$y_var,
          color = "Genre",
          group = "Artists"
        ),
        size = input$size
      ) +
      labs(x = input$x_var, y = input$y_var, title = title) +
      theme(plot.title = element_text(hjust = 0.5)))

    demo_plot
  })
  # Table for avg feature values
  output$importance_table <- renderTable({
    data <- read.csv("data/2018_2017_combined.csv",
      stringsAsFactors = F
    )
    importance <- data %>% dplyr::summarize(
      "Danceability" = round((mean(danceability) / 1), 2),
      "Energy" = round((mean(energy) / 1), 2),
      "Loudness" = round((mean(loudness) / -60), 2),
      "Acousticness" = round((mean(acousticness) / 1), 2),
      "Speechiness" = round((mean(speechiness) / 1), 2),
      "Instrumentalness" = round((mean(instrumentalness) / 1), 2),
      "Liveness" = round((mean(liveness) / 1), 2),
      "Valence" = round((mean(valence) / 1), 2),
      "Tempo" = round(mean(tempo), 2)
    )
    return(importance)
  })
  # Plotting number of instances for past 2 years by genre
  output$genre_count <- renderPlot({
    genre_count <- spotify_data_2017_2018 %>%
      count(genre) %>%
      arrange(-n)
    names(genre_count) <- c("Genre", "Instances")

    ggplot(data = genre_count) +
      geom_col(
        mapping = aes(x = Genre, y = Instances),
        fill = "cornflowerblue"
      ) +
      geom_text(
        aes(x = Genre, y = Instances, label = Instances, vjust = -1)
      )
  })
}
