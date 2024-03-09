#!/bin/bash
 msgFile="msg.txt"

 for u in $(getent passwd | cut -d: -f1)
 do
    mail $u < $msgFile
    echo $u

 done

