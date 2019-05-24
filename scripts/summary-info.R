
# Calculate 5 values from data
# Calculated the average of each audio feature for the top 100 songs for 2017 and 2018.
# Calculated the average of each audio feature for each genre for both 2017 and 2018.
# Calculated the most popular genre(s) for each year.
# Calculated the artist(s) with most songs in top 100 for each year.
# Calculated the audio features, artist and genre for the most danceable song(s).
# Audio Features
# danceability -- how danceable a song is based on combination of musical elements such as 
# tempo, rhythym stability, beat strength, and regularity
# 0 is least danceable, and 1 is most danceable
# energy -- measure of intensity and activity, 1 is fast, loud and noisy
# key -- the estimated key of the track, if no key detected the value is -1
# loudness -- how loud a track is in decibels, range from -60 to 0 db
# mode -- indicate the type of scale from which the melodic content derived, major is 1 
# and minor is 0
# speechiness -- measure of presence of spoken words in track, from 0 to 1
# 0.66 and above is all spoken words, 0.33-0.66 is music and speech, and below 0.33 is music
# accousticness -- a confidence measure of whether a track is acoustic, from 0 to 1.
# instrumental -- measure of vocals, closer to 1, means less vocal content
# tempo -- measure of beats per minute(BPM), speed or pace of song
library("dplyr")
get_summary_info <- function (dataset) {
  summary_info <- list()
  summary_info$audio_features <-  dataset %>%
                           summarize_if(is.numeric, mean, na.rm = T)
  summary_info$genre <- dataset %>%
                           group_by(genre) %>%
                           summarize_if(is.numeric, mean, na.rm = T)
  summary_info$popular_genre <- dataset %>%
                                 group_by(genre) %>%
                                 summarize(times_appear = n()) %>%
                                 filter(times_appear == max(times_appear, na.rm = T)) %>%
                                 select(genre)
  summary_info$popular_artist <- dataset %>%
                                 group_by(artists) %>%
                                 summarize(times_appear = n()) %>%
                                 filter(times_appear == max(times_appear, na.rm = T)) %>%
                                 select(artists)
  summary_info$most_danceable <- dataset %>%
                                 filter(danceability == max(danceability, na.rm = T)) 
  return (summary_info)
}
