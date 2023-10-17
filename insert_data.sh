#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games,teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
    then
    # get winner id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    # if not found
    if [[ -z $WINNER_ID ]]
      then
      # insert winner
        INSERT_WINNER_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
        if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
          then
            echo Inserted to teams, $WINNER
        fi
        # get inserted winner id
        WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi
    # get opponent id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    # if not found
    if [[ -z $OPPONENT_ID ]]
      then
      # insert opponet
      INSERT_OPPONENT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into games, $OPPONENT
      fi
      # get inserted opponent id
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi
    # insert games
    INSERT_GAMES_RESULT="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")"
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo Insert into games, $WINNER - $OPPONENT
    fi
  fi
done
