#!/bin/sh

QUALITY=500k
THREADS=1
TITLE=$(echo $PWD |awk -F/ '{print $(NF)}')
NUM1=$(echo $MOVIE | tr "A-Z" "a-z" | awk -F - '{print $1}' | md5sum| tr -d a-z | cut -b -5)
NAME=MAQ${NUM1}

###################### Get DVD AUDIO Stream for PSP################################################
mplayer -v dvd:// -dvd-device $1 > dvdout.tmp 2>/dev/null
#Get number of audio tracks
grep  "^audio stream:.*language: en" dvdout.tmp
NUMAUD=$(grep "^number of audio channels on disk:" dvdout.tmp| tr -d .| awk -F : '{print $2}')
echo "Number of Audio Tracks on DVD: $NUMAUD"
if [ $NUMAUD -eq 0 ]
then
   echo "No Audio Tracks Found.  Please Investigate..."
   rm -f dvdout.tmp
   exit 1
fi
if [ $NUMAUD -eq 1 ]
then
   echo "Only one audio track, gonna use it"
   rm -f dvdout.tmp
else
   #count how many English languages there are
   NUMENAUD=$(grep -c "^audio stream:.*language: en" dvdout.tmp)
   if [ $NUMENAUD -eq 1 ]
   then
      echo "Only one English audio track, gonna use it"
      ENAUDIO=$(grep "^audio stream:.*language: en" dvdout.tmp | awk '{print $3}')
      NENAUDIO=$(expr $ENAUDIO + 1)
      MAPSWITCH="-map 0.0:0.0 -map 0.${NENAUDIO}:0.1"
   else
      #prefer stereo stream for psp
      STEREOSTREAM=$(grep "^audio stream:.*stereo.*language: en" dvdout.tmp | head -1 | awk '{print $3}')
      FIVEONESTREAM=$(grep "^audio stream:.*5.1.*language: en" dvdout.tmp | awk '{print $3}')
      
      
      if [ -n $STEREOSTREAM ]
      then
         echo "Stereo Found.  Will use stereo"
         NENAUDIO=$(expr $STEREOSTREAM + 1)
         MAPSWITCH="-map 0.0:0.0 -map 0.${NENAUDIO}:0.1"
      elif [ -z $FIVEONESTREAM ]
      then
         echo "No 5.1 sound found.  Please investigate:"
         grep  "^audio stream:.*language: en" dvdout.tmp
         exit 1
      else
         echo "No Stereo Found.  Will use 5.1"
         NENAUDIO=$(expr $FIVEONESTREAM + 1)
         MAPSWITCH="-map 0.0:0.0 -map 0.${NENAUDIO}:0.1"
      fi
   fi
fi
rm -f dvdout.tmp
echo $MAPSWITCH
################################################################################3


if [ -e ./.CONVERTED-TO-PSP ]
then
   echo "CONVERTED FILE Found"
   echo 'This has probably already been converted!'
   exit 1
fi
mplayer dvd:// -dumpstream -dvd-device $1
#Pass 1
ffmpeg -threads $THREADS -y -i stream.dump -s 480x272 -vcodec libx264 -b $QUALITY -flags +loop -cmp +chroma -me_range 16 -g 300 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -rc_eq "blurCplx^(1-qComp)" -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -coder 0 -refs 1 -bt $QUALITY -maxrate 4M -bufsize 4M -level 21  -r 30000/1001 -partitions +parti4x4+partp8x8+partb8x8 -me hex -subq 5 -f psp -aspect 480:272 -title "$TITLE" -acodec libfaac -ac 2 -ar 48000 -ab 128 -pass 1 "$NAME.mp4"
#Pass 2
ffmpeg -threads $THREADS -y -i stream.dump -s 480x272 -vcodec libx264 -b $QUALITY -flags +loop -cmp +chroma -me_range 16 -g 300 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -rc_eq "blurCplx^(1-qComp)" -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -coder 0 -refs 1 -bt $QUALITY -maxrate 4M -bufsize 4M -level 21  -r 30000/1001 -partitions +parti4x4+partp8x8+partb8x8 -me hex -subq 5 -f psp -aspect 480:272 -title "$TITLE" -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 384  "$NAME.MP4"
if [ $? -eq 0 ]
then
   #Picture
   ffmpeg -y -i stream.dump -f image2 -ss 30 -vframes 1 -s 160x120 -an $NAME.THM
   touch .CONVERTED-TO-PSP
fi
rm -f *log
rm -f *dump
