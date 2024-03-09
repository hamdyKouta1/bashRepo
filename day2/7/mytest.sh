#!/usr/bin/bash


if [ -f $1 ]
then
        echo "this is file"
else
        echo "this is directory"
fi

if [ -r $1 ]
	then
        echo "is readable"
else
        echo "not readable"
fi

if [ -x $1 ]
        then
        echo "is executable"
else
        echo "not executable"
fi

if [ -w $1 ]
        then
        echo "is writable"
else
        echo "not writable"
fi


