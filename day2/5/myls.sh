#!/usr/bin/bash


if [ $# -le 1  ]
then
        ls $* $HOME
else
        ls $*
fi

