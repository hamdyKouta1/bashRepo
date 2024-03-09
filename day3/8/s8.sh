#!/bin/bash

select name in listAll listAll-A exit
do
case $REPLY in
3)
break
;;

1)
echo $(ls $HOME)
;;

2)
echo $(ls -a $HOME)  
;;

*)
echo invalid input
;;
esac

done 
