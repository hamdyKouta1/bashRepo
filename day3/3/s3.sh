#!/bin/bash
#export LC_COLLATE=C
shopt -s extglob


read -p "please enter the dir of the target file : " dir

for f in $(ls $dir/*)
do
    chmod u+x $f
    echo done $f
done