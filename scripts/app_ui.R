library("shiny")
library("ggplot2")

page_one <- tabPanel(
  "",
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      # Widget to choose variable for analysis on y axis
      selectInput(
        inputId = "",
        label = "",
        choices = colnames_fixed_plot
      ),
      # Widget to choose size of points on total population statistics plot
      sliderInput(
        inputId = "",
        label = h3(""),
        min = 0,
        max = 10,
        value = 5
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

