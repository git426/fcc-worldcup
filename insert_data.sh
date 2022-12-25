#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo  $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $WINNER != "winner" ]]
    then
    #get team_winner
    TEAM_WINNER=$($PSQL "select name from teams where name='$WINNER'")

      if [[ -z $TEAM_WINNER ]]
      #insert team_winner
      then
      INSERT_TEAM_WINNER=$($PSQL "insert into teams(name) values('$WINNER')")
      fi
        if [[ $INSERT_TEAM_WINNER == "INSERT 0 1" ]]
        then
        echo Inserted into name, $WINNER
        fi
    fi

    if [[ $OPPONENT != "opponent" ]]
    then
    #get team_opponent
    TEAM_OPPONENT=$($PSQL "select name from teams where name='$OPPONENT'")

      if [[ -z $TEAM_OPPONENT ]]
      #insert team_opponent
      then
      INSERT_TEAM_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      fi
        if [[ $INSERT_TEAM_OPPONENT == "INSERT 0 1" ]]
        then
        echo Inserted into name, $OPPONENT
        fi
    fi
  done

  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != "year" ]]
     then
     #get winner_id
     WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
     #get opponent_id
     OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
     #insert game detail
      INSERT_GAME_DETAIL=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        if [[ $INSERT_GAME_DETAIL == "INSERT 0 1" ]]
          then
          echo Insert into year: $YEAR, round: $ROUND, winner: $WINNER_ID, opponent_id: $OPPONENT_ID, winner_goal: $WINNER_GOALS, opponent_goal: $OPPONENT_GOALS 
        fi
    fi
  done