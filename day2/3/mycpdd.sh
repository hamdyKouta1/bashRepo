#!/usr/bin/bash
echo "${*: -1}"
if [ -f ${*: -1} ]
then 
cp $*

else

cp -R $*
fi
