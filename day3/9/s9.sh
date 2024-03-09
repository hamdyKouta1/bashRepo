
#!/bin/bash
#export LC_COLLATE=C
shopt -s extglob


read -p "please enter the number of array : " number

declare -a arr

for ((i=0;i<$number;i++))
do
read -p "please enter value# " arr[$i]
done

echo ${arr[@]}