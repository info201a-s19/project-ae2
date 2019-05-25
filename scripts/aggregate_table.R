The second file you should save in your scripts/ directory should contain a 
function that takes in a dataset as a parameter, and returns a table of aggregate
information about it. It must perform a groupby operation to show a dimension of 
the dataset as grouped by a particular feature (column). We expect the included
table to:
  
  Have well formatted column names
Only contain relevant information
Be intentionally sorted in a meaningful way
You must also describe why you included the table, and what information it reveals.

# Load packages, data
library(dplyr)
data <- read.csv("../data/2018_2017_combined.csv", stringsAsFactors = F)

# Function to match key integer with Pitch Scale
match_key <- function(col) {
  case_when(
    col == 0  ~"C",
    col == 1  ~"C#/Db",
    col == 2  ~"D",
    col == 3  ~"D#/Eb",
    col == 4  ~"E",
    col == 5  ~"F",
    col == 6  ~"F#/Gb",
    col == 7  ~"G",
    col == 8  ~"G#/Ab",
    col == 9  ~"A",
    col == 10 ~"A#/Bb",
    col == 11 ~"B"
  )
}

# Function to add pitch column
add_key <- function(df) {
  df %>% 
    mutate("Pitch" = match_key(df$key))
}


# Function to create table with summary info (grouped by genre)
summarize_genre_table <- function(df) {
  with_key <- add_key(df)
  summarized <- with_key %>% 
    group_by(genre) %>%
    summarize(
      "Example" = paste0(first(name), " -- by ", first(artists), ""),
      "Number" = n(),
      "Pitch" = count(with_key, Pitch) %>% 
                      arrange(-n) %>%
                      filter(n == max(n)) %>% 
                      pull(Pitch)
        ,
      "Valence (avg)" = round(mean(valence),2),
      "Tempo (avg)" = round(mean(tempo),2),
      "Danceability (avg)" = round(mean(danceability),2),
      "Energy (avg)" = round(mean(energy),2),
      "Acousticness (avg)" = round(mean(acousticness),2),
      "Instrumentalness (avg)" = round(mean(instrumentalness),2),
      "Percentage Major" = round(sum(mode) / Number * 100, 2)
  ) %>% 
    arrange(-Number)
}

most_common_pitch <- function(df) {
  df %>% 
    count(Pitch) %>% 
    filter(n == max(n)) %>% 
    pull(Pitch)
}


table <- summarize_key_table(data)
