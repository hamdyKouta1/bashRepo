#!/bin/bash

echo "What Is Your UserName"
read answer

username="$answer"

if awk -F':' -v u="$username" '$1 == u { found=1; exit } END { exit !found }' /etc/passwd; then
    echo "User $username found in the user list."
    echo "Hello: $answer."
    id_result=$(id "$answer")
    echo "$id_result"
    ls_result=$(ls -l /home/"$answer")
    echo "$ls_result"
    ps -u "$username"
    sudo cp -R /home/"$answer"/Documents/copy ./tmp/usr
else
    echo "User $username not found in the user list."
fi


