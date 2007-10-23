#!/bin/sh

QUALITY=400k
THREADS=1
TITLE=$(echo $PWD |awk -F/ '{print $(NF)}')

if [ -e ./.CONVERTED-TO-IPHONE ]
then
   echo "CONVERTED FILE Found"
   echo 'This has probably already been converted!'
   exit 1
fi

#Pass 1
ffmpeg -threads $THREADS -y -i $1 -s 480x272 -vcodec libx264 -b $QUALITY -flags +loop -cmp +chroma -me_range 16 -g 300 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -rc_eq "blurCplx^(1-qComp)" -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -coder 0 -refs 1 -bt $QUALITY -maxrate 4M -bufsize 4M -level 21  -r 30000/1001 -partitions +parti4x4+partp8x8+partb8x8 -me hex -subq 5 -f mp4 -aspect 480:272 -title "$TITLE" -acodec libfaac -ac 2 -ar 48000 -ab 128 -pass 1 "$TITLE.mp4"
#Pass 2
ffmpeg -threads $THREADS -y -i $1 -s 480x272 -vcodec libx264 -b $QUALITY -flags +loop -cmp +chroma -me_range 16 -g 300 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -rc_eq "blurCplx^(1-qComp)" -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -coder 0 -refs 1 -bt $QUALITY -maxrate 4M -bufsize 4M -level 21  -r 30000/1001 -partitions +parti4x4+partp8x8+partb8x8 -me hex -subq 5 -f mp4 -aspect 480:272 -title "$TITLE" -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 320 "$TITLE.mp4"
if [ $? -eq 0 ]
then
   touch .CONVERTED-TO-IPHONE
fi
rm -f *log
rm -f *dump