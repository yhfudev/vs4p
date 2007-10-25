#!/bin/sh

VNAME=`echo ${1%.*}`
NEWNAME=\"$1\"
LOG=convertpsp.log
SHOW=$(echo $PWD |awk -F/ '{print $(NF)}')
TITLE=$(echo $SHOW | sed -e 's/_-/-/g' -e 's/-_/-/g' )
NUM2=$(echo $SHOW | awk -F - '{print $2}'  | tr -d x  | tr -d _)
NUM1=$(echo $SHOW | tr "A-Z" "a-z" | awk -F - '{print $1}' | md5sum| tr -d a-z | cut -b -2)
NAME=MAQ${NUM1}${NUM2} 
echo $NEWNAME

if [ -e ./.CONVERTED-TO-PSP ]
then
   echo "CONVERTED FILE Found"
   echo 'This has probably already been converted!'
   exit 1
fi
ffmpeg -threads 4 -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b 512k -pass 1 -f psp $NAME.MP4
ffmpeg -threads 4 -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b 512k -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 384 -f psp $NAME.MP4
#Picture
ffmpeg -y -i "$1" -f image2 -ss 10 -vframes 1 -s 160x120 -an $NAME.THM
rm -f *log
touch .CONVERTED-TO-PSP
