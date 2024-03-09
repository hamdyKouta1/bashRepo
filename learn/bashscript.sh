# a -> append after the cursur
# #!/bin/bash to confirm that we using bash shell
# > overwrite >> append


:'


how to create array in bash 

my_arr=(one two three four five)

to display the arr {my_arr[@]}

to display the first elem the arr {my_arr[0]}
 

FOR looops

for item in ${my_arr[@]};
do
echo -n $item | wc -c; 
done


sed '' Path/to/file -> print all data in screen

sed -n '' Path/to/file ->no print 

sed -n 'address+command'
        fixedline        s -> replace
        regex            d -> delete
        range of line    p -> print


sed 's/ahmed/ali' /path/to/file first hit
sed 's/ahmed/ali/2' /path/to/file sec hit 
sed 's/ahmed/ali/g' /path/to/file global
sed -n 's/ahmed/ali/gp' /path/to/file global

sed -n -e 's/ahmed/ali/gp' -e '' -e '' /path/to/file global

readarry to store the out but in  array







'