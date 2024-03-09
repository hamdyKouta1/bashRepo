#!/bin/bash
#export LC_COLLATE=C
shopt -s extglob
read -p "please enter char: " variable

case $variable in

+([0-9]))
echo number case
;;

+([a-z]))
echo small case
;;

+([A-Z]))
echo cap case
;;

+([a-zA-Z]|[[:space:]]))
echo mix case
;;

*)
echo invaled
;;

esac