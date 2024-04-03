#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    exit
fi    

#Input (Atomic Number, Symbol or Name)
#Atomic Number
  if [[ $1 =~ ^[1-9]+$ ]]
    then
      element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = '$1'")
#Symbol or Name
    else
      element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
  fi      

  #If input doesn't exist as atomic_number, symbol or name
  if [[ -z $element ]]
    then
    #Output
      echo "I could not find that element in the database."
      exit
  fi  

  #If input matches element in database
    echo $element | while IFS=" |" read an name symbol type mass mp bp 
      do
    #Output
     echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
      done
   
     