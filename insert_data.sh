#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != 'winner' ]]
  then
  NAME=$($PSQL "select name from teams where name='$WINNER'")
  if [[ -z $NAME ]]
    then
    INSERT_NAME=$($PSQL "insert into teams(name) values ('$WINNER')")
    if [[ $INSERT_NAME == "INSERT 0 1" ]]
      then echo Inserted name, $WINNER
    fi
  fi
fi
if [[ $OPPONENT != 'opponent' ]]
  then
  NAME=$($PSQL "select name from teams where name='$OPPONENT'")
  if [[ -z $NAME ]]
    then 
    INSERT_NAME=$($PSQL "insert into teams(name) values ('$OPPONENT')")
    if [[ $INSERT_NAME == "INSERT 0 1" ]]
      then echo Inserted name, $OPPONENT
    fi
  fi
fi
if [[ $YEAR != 'year' ]]
  then 
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  INSERT_VALUE=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  if [[ $INSERT_VALUE == "INSERT 0 1" ]]
    then echo Inserted a row
  fi
fi
done
