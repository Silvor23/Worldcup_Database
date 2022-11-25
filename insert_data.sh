#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
		do
  		if [[ $WINNER != "winner" ]]
  			then
  				# get team_id
  				TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  				# if not found
   				if [[ -z $TEAM_ID ]]
    				then
      				# insert team
      				INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      				if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      					then
       						echo Inserted into teams, $WINNER
      				fi
      				# get new team_id
      				TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    				fi
					TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  				# if not found
   				if [[ -z $TEAM_ID ]]
    				then
      				# insert team
      				INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      				if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      					then
       						echo Inserted into teams, $OPPONENT
      				fi
      				# get new team_id
      				TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    				fi
			fi
		done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
	do
		if [[ $YEAR != "year" ]]
  			then
				WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
				echo $WINNER_ID
				OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
				echo $OPPONENT_ID
      	INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES ($YEAR,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS,'$ROUND')")
			fi
		done