# Function to create table with summary info (grouped by genre)
summarize_genre_table <- function(df) {
  table <- df %>%
    group_by(genre) %>%
    summarize(
      "Example" = paste0(first(name), " -- by ", first(artists), ""),
      "Number" = n(),
      "Valence (avg)" = round(mean(valence), 2),
      "Tempo (avg)" = round(mean(tempo), 2),
      "Danceability (avg)" = round(mean(danceability), 2),
      "Energy (avg)" = round(mean(energy), 2)
  ) %>%
    arrange(-Number) %>%
    rename(Genre = genre)
  return(table)
}
