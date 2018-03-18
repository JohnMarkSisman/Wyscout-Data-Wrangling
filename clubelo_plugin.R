clubelo_plugin <- function(wyscout_data_directory,team_names_directory,new_file_directory){
require(readr)
require(readxl)
require(dplyr)
require(magrittr)

#Import relevant files
wyscout_data <- read_excel(as.character(wyscout_data_directory))
team_names <- read_csv(as.character(team_names_directory))

#Get today's date as string in yyyy-mm-dd format:
today <- as.character(Sys.Date())

#Create today's API URL
apiurl <- paste0("http://api.clubelo.com/",today)

#Send API request
clubelo <- read_csv(apiurl,col_names = TRUE)

#Initialise column
clubelo$av_domestic_opp_elo <- NA

#For each team, find the average ELO of it's domestic opponents
for (i in 1:nrow(clubelo)){
  domestic <- filter(clubelo, Country == clubelo$Country[i], Level == clubelo$Level[i],Club!=clubelo$Club[i])
  mean_elo <- mean(domestic$Elo)
  clubelo$av_domestic_opp_elo[i] <- mean_elo
}

#For each team, find the difference between their ELO and the average of their domestic opponents (subtraction
#rather than ratio as p(win) for a team in a given match-up is related to the difference in ELO rating)
clubelo <- mutate(clubelo,av_domestic_elo_diff = Elo - av_domestic_opp_elo)

#Transcribe ELO, average opposition ELO and average ELO differential to wyscout data table
wyscout_data <- mutate(wyscout_data,clubelo_name = team_names$clubelo_name[match(Team, team_names$wyscout_name)],
                       Elo = clubelo$Elo[match(clubelo_name, clubelo$Club)],
                       av_domestic_opp_elo = clubelo$av_domestic_opp_elo[match(clubelo_name, clubelo$Club)],
                       av_domestic_elo_diff = clubelo$av_domestic_elo_diff[match(clubelo_name, clubelo$Club)])
wyscout_data <- select(wyscout_data,-clubelo_name)

#Save data
write_excel_csv(wyscout_data,paste0(new_file_directory,".csv"))
}
