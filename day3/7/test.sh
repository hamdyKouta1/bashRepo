#!/bin/bash

declare -i n1  # declare n1 as integer
declare -i n2  # declare n2 as integer
n1=1           # set n1 = 1
n2=1           # set n2 = 1

while [ $n1 -eq $n2 ]; do  # while n1 equals n2
    ((n2=n2+1))             # increment n2 by 1
    echo $n1                # print n1
    if [ $n1 -gt $n2 ]; then  # check if n1 is greater than n2
        break                 # if true, break the loop
    else
        continue              # otherwise, continue
    fi
    ((n1=n1+1))             # increment n1 by 1
    echo $n2                # print n2
done
