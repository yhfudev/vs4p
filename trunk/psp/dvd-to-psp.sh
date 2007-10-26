#!/bin/sh

if [ $# -ne 1 ]; then
   echo "usage: $(basename $0) <dvd.iso>"
   exit 1
fi

while getopts "b:t:h" flag
do
   case $flag in
      b )
         BITRATE="$OPTARG"
      ;;
      t )
         THREADS="$OPTARG"
      ;;
      h )
         echo "Usage: `basename $0` [-b bitrate] [-t numOfThreads] [-h]"
         echo "    -b   Specify the Bitrate.  Should be between 200k and 1500k."
         echo "         Note: The \"k\" is needed.  e.g. \"512k\""
         echo "    -h   help (this help message)"
         echo "    -t   Specify the number of threads. This will default to the number of CPUS found."
         echo ""
         echo "example:  `basename $0` -b 512k -t 2 some_video_file.avi"
         exit 1
      ;;
      \? )
         echo "Usage: `basename $0` [-b bitrate] [-t numOfThreads] [-h]"
         echo "Use \"`basename $0` -h\" for more information"
         exit 1
      ;;
      * )
         echo "Usage: `basename $0` [-b bitrate] [-t numOfThreads] [-h]"
         echo "Use \"`basename $0` -h\" for more information"
         exit 1
      ;;
   esac
done

if [ -z "$BITRATE" ] 
then
   BITRATE=300k
fi

if [ -z "$THREADS" ] 
then
   THREADS=$(grep -c "^processor" /proc/cpuinfo)
fi

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
ffmpeg -threads $THREADS -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b $BITRATE -pass 1 -f psp $NAME.MP4
#Pass 2
ffmpeg -threads $THREADS -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b $BITRATE -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 384 -f psp $NAME.MP4
if [ $? -eq 0 ]
then
   #Picture
   ffmpeg -y -i stream.dump -f image2 -ss 30 -vframes 1 -s 160x120 -an $NAME.THM
   touch .CONVERTED-TO-PSP
fi
rm -f *log
rm -f *dump
