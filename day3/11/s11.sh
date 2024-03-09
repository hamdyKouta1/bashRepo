
#!/bin/bash
#export LC_COLLATE=C
shopt -s extglob
read -p "please enter the number of array : " number

add(){
((sum=$1 * $1))
return $sum
}
add number
echo $?