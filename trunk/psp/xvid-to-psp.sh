#!/bin/sh

QUALITY=512k
THREADS=4
MOVIE=$(echo $PWD |awk -F/ '{print $(NF)}')
NUM1=$(echo $MOVIE | tr "A-Z" "a-z" | awk -F - '{print $1}' | md5sum| tr -d a-z | cut -b -5)
NAME=MAQ${NUM1}

if [ -e ./.CONVERTED-TO-PSP ]
then
   echo "CONVERTED FILE Found"
   echo 'This has probably already been converted!'
   exit 1
fi

#Pass 1
ffmpeg -threads $THREADS -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b 512k -pass 1 -f psp $NAME.MP4
#Pass 2
ffmpeg -threads $THREADS -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b 512k -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 384 -f psp $NAME.MP4
if [ $? -eq 0 ]
then
   #Picture
   cat $1 | ffmpeg -y -i - -f image2 -ss 30 -vframes 1 -s 160x120 -an $NAME.THM
   touch .CONVERTED-TO-PSP
fi
rm -f *log
rm -f *dump
