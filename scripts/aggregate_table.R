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




# Function to create table with summary info (grouped by genre)
summarize_genre_table <- function(df) {
  table <- df %>% 
    group_by(genre) %>%
    summarize(
      "Example" = paste0(first(name), " -- by ", first(artists), ""),
      "Number" = n(),
      "Valence (avg)" = round(mean(valence),2),
      "Tempo (avg)" = round(mean(tempo),2),
      "Danceability (avg)" = round(mean(danceability),2),
      "Energy (avg)" = round(mean(energy),2)
  ) %>% 
    arrange(-Number) %>% 
    rename(Genre = genre)
  return(table)
}
