library("shiny")
library("ggplot2")
#for violin plot
spotify_data_2017_2018 <- read.csv("data/2018_2017_combined.csv", 
                                   stringsAsFactors = F)
violin_plot_data_2017 <- spotify_data_2017_2018 %>%
  filter( genre == "Pop" & year == "2017")
violin_plot_data_2018 <- spotify_data_2017_2018 %>%
  filter( genre == "Hip-Hop/Rap" & year == "2018")}
violin_page <- tabPanel(
  "Genres and Audio Features",
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      # Widget to choose variable for analysis on y axis
      selectInput(
        inputId = "feature",
        label = "Feature",
        choices = colnames(spotify_data_2017_2018)
      ),
      # Widget to choose size of points on total population statistics plot
      selectInput(
        inputId = "genre",
        label = "Genre",
        choices = colnames(spotify_data_2017_2018)
      )
    ),
    # total population statistics plot output
    mainPanel(
      plotOutput(outputId = "", width = "100%", height = "700px"),
      verbatimTextOutput(outputId = "")
    )
  )
)


# Poverty Statistics Page
page_two <- tabPanel(
  "",
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      # Widget to choose poverty statistic for analyis on y axis
      radioButtons("",
                   label = h3(""),
                   choices = c()
      ),
      # Widget to choose size of bars on poverty statistics plot
      sliderInput(
        inputId = "",
        label = "",
        min = 0, max = 1, value = 0.5
      )
    ),
    # poverty statistics plot output
    mainPanel(
      plotOutput(outputId = "", width = "100%", height = "700px")
    )
  )
)

# Define UI for application
ui <- navbarPage(
  "",
  page_one,
  page_two
)

