#! /usr/bin/bash
#export LC_COLLATE=C
shopt -s extglob

#read -p "enter your name: " value

<<COMMENT
case $value in
"mahmoud")
echo hello manager
;;
"ahmed")
echo hello boss 
;;
*)
echo invalid input
;;
esac


case $value in
+([a-zA-Z]|[[:space:]]))
echo mixed letters
;;
*([a-z]))
echo a-z with astrik
;;
@([a-z]))
echo a-z
;;

a*)
echo start with a
;;
b?)
echo only two letters
;;
c[de])
echo cd or ce
;;

me?(ee)t)
echo met or meet
;;
+([a-z]))
echo small char
;;
+([a-z])@([1-9]))
echo small char with single number
;;
+([a-z1-9]))
echo small char with numbers
;;
+([1-9]))
echo  Numbers
;;
*)
echo invalid input
;;
esac
COMMENT
#echo "today is $(date)"
#num=1
: '
while [ $num -lt 10 ]
do
echo $num
((num++))
done

until [ $num -gt 10 ]
do
echo $num
((num++))
done

read -p "Please enter DirName: " dir

for hamda in $(ls $dir/*)
do
#chmod u-x $hamda
echo $hamda
done


declare -a arr

for ((i=0;i<3;i++))
do
read -p "please enter value# " arr[$i]
done

echo ${arr[@]}

select name in ahmed mahmoud mostafa exit
do
case $REPLY in
"exit")
break
;;
"mahmoud")
echo hello manager
;;
"ahmed")
echo hello boss 
;;
"mostafa")
echo hello sasa
;;
*)
echo invalid input
;;
esac

done 


hello(){
echo hello world
}
hello

function hello2(){
echo hello world2
}
hello2

add(){
	((sum=6+6))
	return $sum
}

add
result=$?
echo $result

add2(){
echo hello world
	((sum=6+6))
	echo $sum
}
result=$(add2)
echo $sum
echo -----------------------
echo $result


add(){
echo mahmoud
((sum=5+6))
return $sum
}
add 
echo $sum
#echo $?


add2(){
echo mahmoud
((sum=5+6))
echo $sum
}
result=$(add2)
echo $?

echo $sum

echo $result

add2(){
echo $@
((sum=$1+$2))
return $sum
}

result=$(add2 5 9)
echo $?
echo $result
'

# createDB --> create directory
line=""
for ((i=0;i<3;i++))
do
read -p "please enter your ID: " name
line+=:$name
done

echo ${line:1}






















