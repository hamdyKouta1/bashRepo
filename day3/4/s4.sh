

#!/bin/bash
#export LC_COLLATE=C
shopt -s extglob


read -p "please enter the dir of the target file : " dir

for f in $(ls $dir/*)
do
    if [ -f $f ]
    then
        tar -rvf ~/Documents/bash/day3/4/backup.tar.gz $f
        echo done $f
    fi 

done