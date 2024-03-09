#!/bin/bash

# Display a dialog box asking for the user's name
name=$(zenity --entry --title "Welcome" --text "Enter your name:")

# Display a dialog box with a message
zenity --info --title "Greetings" --text "Hello, $name! Welcome to our Bash GUI."

# Display a dialog box with a Yes/No  prompt
zenity --question --title "Confirmation" --text "Do you like using Bash?"

# Check the exit status of the previous command (Yes = 0, No = 1)
if [ $? -eq 0 ]; then
    zenity --info --title "Feedback" --text "That's great to hear, $name!"
else
    zenity --info --title "Feedback" --text "Sorry to hear that, $name. We'll try to improve!"
fi
