# Wyscout-Data-Wrangling

clubelo_plugin.R is a script for augmenting a dataset containing team names with ELO team ratings from today's http://clubelo.com/API
The following columns are added:
- ELO rating for the team in question
- Average ELO rating for all of that team's domestic league opponents (as a measure of strength of schedule across the season)
- Team ELO rating - Average domestic oppoisition ELO rating (as a measure of relative ease of eaverage fixture)
The file path to the dataset to be augmented in .xlsx format must be given at the first argument to the function call.

ClubElo uses abbreviated team names in their dataset, so clubelo_plugin.R must reference a look-up table to match team names as they appear on ClubElo to the corresponding names as they appear in the original dataset. One such look-up table for matching against Wyscout team names is found at "team_names.csv". Note that the file path to the lookup table must be given as the second argument to the function call.

The path to save the augmented data to must be given as the third and final argument to the function call (without file suffix - the resultant file is an Excel_csv file)
