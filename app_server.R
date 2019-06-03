
my_server <- function(input, output) {
  # What is the distribution for an audio feature
  # for a particular genre(e.g.pop)? How does it compare to another genre?
  #Load necessary packages
  library(stringr)
  library(ggplot2)
  library(dplyr)
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
  #First Violin plot
  output$violin_plot <- renderPlot({
    ggplot(data = violin_plot_data(), aes(x = genre)) +
      geom_violin(aes_string(y = eval(input$feature)), fill = "steelblue") +
      labs(
        title = paste(str_to_title(input$feature), " for ", input$genre,
          " in 2017 and 2018",
          sep = ""
        ),
        x = "Genre",
        y = str_to_title(input$feature)
      ) +
      # Assign characteristics to titles in plot
      theme(
        plot.title = element_text(size = 26, face = "bold"),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 14),
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 14, face = "bold"),
        aspect.ratio = 1
      )
  })
  #Second Violin Plot, if user wants to compare
  output$violin_plot_2 <- renderPlot({
    if (input$add_genre == T) {
      ggplot(data = violin_plot_data_second_genre(), aes(x = genre)) +
        geom_violin(aes_string(y = eval(input$feature)), fill = "steelblue") +
        labs(
          title = paste(str_to_title(input$feature),
            " for ", input$second_genre,
            " in 2017 and 2018",
            sep = ""
          ),
          x = "Genre",
          y = str_to_title(input$feature)
        ) +
        #Text Characteristics added to Plot
        theme(
          plot.title = element_text(size = 26, face = "bold"),
          axis.title = element_text(size = 14, face = "bold"),
          axis.text = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14, face = "bold"),
          aspect.ratio = 1
        )
    }
  })
}
