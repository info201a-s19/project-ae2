# SHINY APP LINK
https://aseshan.shinyapps.io/project-ae2/
# Final Project
Use this `REAMDE.md` file to describe your final project (as detailed on Canvas).

### 1. Why are you interested in this field/domain?
Audio is key to pop culture, and is becoming a bigger influencer everyday,
spreading important messages, such as in podcasts and in songs such as
"This is America".

Almost everyone listens to music at some point in their day, often as for leisure to relieve stress or to relax or whatnot,
and it can be insightful to see the trends and interactions of how different locations/cultures/regions share
similar musical tastes, or how people connect their music choices to
other general aspects of everyday life, like mood, time, season, weather, activities, etc.  

The field of music is interesting because it is a big part of our lives. The music a person chooses to listen to is a form of self expression and and can tell a lot about a person's long standing temperament as well as their mood at a given time. Aside from individual insights it can also form connections and bring out insights about different populations in many differing domains and we are interested in exploring what connections can be found in human behaviors and musical interests as well as the increased popularity of podcasts.

### 2. What other examples of data driven project have you found related to this domain (share at least 3)?

Listening Diversity Increases nearly 40 Percent on Spotify:
https://insights.spotify.com/us/2017/11/02/listening-diversity-spotify/  

The amount of artists listened to per week in Spotify has dramatically increased
from 2016 to 2017 due to programmed playlists in Spotify such as
"Fresh Finds", "Today's Top Hit's", "Summer Rewind", etc.

How Students Listen - 2017:
https://insights.spotify.com/us/2017/05/24/how-students-listen-2017/  

This visualization allows users an interactive way to explore how each university listens to music on multiple different levels. It sorts the schools by various audio acoustics and stacks up school in listening frequency and listening diversity. As well as showing top genres for each school and distincitive tracks and artists of each school.

How Weather Affects Music Listening:
https://insights.spotify.com/us/2017/02/07/spotify-accuweather-music-and-weather/  

This project followed the question of whether people make different music-listening decisions based on the weather. Some findings included sunnier days brought higher-energy, happier sounding music, contrastly rainier days people tended to listen to low energy, sadder music. Seattle and Chicago are more impacted by overcast days than rainy ones, and so many more interesting findings.

Spotify Music Data Analysis Project:
https://github.com/AsTimeGoesBy111/Spotify-Music-Data-Analysis  

The Spotify dataset was used to analyze the trend of music development over the past 20 years. The data generated graphs to analyze of popularity trends by genre and numeric features while showing predicted areas of growth in upcoming years.   

### 3. What data-driven questions do you hope to answer about this domain (share at least 3)?
Which countries stream the top songs on the charts the most? <br/>
What artist is common amongst all countries?<br/>
How do musical trends change throughout the year in different regions?<br/>
What does genre popularity look like over the past decade or so?<br/>
Types of music people generally listen to in the morning vs at night?

## Finding data

### Identify and download at least 3 sources of data related to your domain of interest described above (into a folder you create called data/). You won't be required to use all of these sources, but it will give you practice discovering data. If your data is made available through a Web API, you don't need to download it. For each source of data, provide the following information:

- Where did you download the data (e.g., a web URL)?
- How was the data collected or generated? Make sure to explain who collected the data (not necessarily the same people that host the data),and who or what the data is about?
- How many observations (rows) are in your data?
- How many features (columns) are in the data?
- What questions (from above) can be answered using the data in this dataset?

Spotify's Worldwide daily song ranking: Which countries stream the top songs on the charts the most?: <br/>
https://www.kaggle.com/edumucelli/spotifys-worldwide-daily-song-ranking <br/>
The data was collected using a crawler created by edumucelli, who has a Ph.D. in Computer Science at École Polytechnique, France.
There are 7 features in the data - Position, Track Name, artists, streams, url, date, and region and 3441197 rows <br/>

Spotify Song Attributes: An attempt to build a classifier that can predict song likeability  
https://www.kaggle.com/geomack/spotifyclassification/version/1 <br/>
Data collected by Spotify, also available via API, and hosted by user geomack on kaggle. Contains x2017 songs (rows), with 17 columns, representing song name, artist, and various song attributes, including danceability, energy, acousticness, valence, liveliness, etc. as determined by Spotify.  
Further information on how these attributes were determined can be found here:  
https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-features/  
Can be used to identify trends in song moods and correlation to time of day / year / season.  

Top Spotify Tracks of 2018: Audio features of top Spotify songs  
https://www.kaggle.com/nadintamer/top-spotify-tracks-of-2018?fbclid=IwAR0_Qmkt_lFc7huHMdBhVDT_F4BxkFhjJ4qy377TL0fxL8Nrq4-sgeXXurY  
Used to answer the question what do all top songs have in common in a given year? Contains 100 rows (songs) with 16 columns, similar to the above dataset. Published by Spotify, and hosted on Kaggle by Nadin Tamer.

Music Label Dataset: Popularity of a song in correlation with the duration of the song
https://www.kaggle.com/thaisneubauer/million-song-dataset-studies
This data is the result of cleaning up data from the MSD subset. Contains 6 columns and  10000 rows. Can identify the duration, key, song hottness, tempo and time signature of songs. Uses the Million Song dataset.
