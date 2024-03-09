
#!/bin/bash
#export LC_COLLATE=C
shopt -s extglob


read -p "please enter the number of array : " number

declare -a arr

for ((i=0;i<$number;i++))
do
read -p "please enter value# " arr[$i]
done
let sum=0

for ((i=0;i<$number;i++))
do
((sum=sum+arr[$i]))
done
average=$(bc <<< "scale=2; $sum / $number")

echo $average