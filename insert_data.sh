#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE games, teams"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get winner id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    #if data not exist
    if [[ -z $WINNER_ID ]]
    then
      #insert data
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    #get opponent id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    #if data not exist
    if [[ -z $OPPONENT_ID ]]
    then
      #isnert data
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi

    #insert game
    INSERT_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done 
