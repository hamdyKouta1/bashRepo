#!/bin/bash
 
 
read -p "please enter the user name  : " usr
let i=0
 while [ $i -lt 10 ]
 do
    echo $i
    
    echo $(mail -u $usr)
    ((i++))
    sleep 5
 done

