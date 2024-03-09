typeset –i n1  #make integer number
typeset –i n2   #make integer number
n1=1 #set n1 =1
n2=1 #set n2=1
while test $n1 –eq $n2 #make while with condition n1 should equal n2
do
n2=$n2+1 # errr
print $n1 #print n1
if [ $n1 –gt $n2 ] #check if n1 > n2
then
break # if true break the loop
else 
continue # continue 
fi
n1=$n1+1 # err
print $n2

done

1