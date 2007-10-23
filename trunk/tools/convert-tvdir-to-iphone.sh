#!/bin/sh -x

if [ -n "$1" ]
then
   DIR=$1
else 
   DIR="."
fi

find "$DIR" -iname "*sample*" -type f -size -30M -print0  | xargs -0 rm 

for i in $DIR/*
do
   if [ -d "$i" ]
   then 
      pushd "$i"
      tv-to-iphone.sh *avi
      popd
   fi
done
