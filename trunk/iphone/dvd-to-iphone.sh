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

###################### Get DVD AUDIO Stream for iPhone################################################
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

if [ -e ./.CONVERTED-TO-IPHONE ]
then
   echo "CONVERTED FILE Found"
   echo 'This has probably already been converted!'
   exit 1
fi
#dump dvd stream from ISO
mplayer dvd:// -dumpstream -dvd-device $1
#Pass 1
ffmpeg -threads $THREADS -y -i stream.dump -s 480x272 -vcodec libx264 -b $BITRATE -flags +loop -cmp +chroma -me_range 16 -g 300 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -rc_eq "blurCplx^(1-qComp)" -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -coder 0 -refs 1 -bt $BITRATE -maxrate 4M -bufsize 4M -level 21  -r 30000/1001 -partitions +parti4x4+partp8x8+partb8x8 -me hex -subq 5 -f mp4 -aspect 480:270 -title "$TITLE" -acodec libfaac -ac 2 -ar 48000 -ab 128 -pass 1 "$TITLE.mp4"
#Pass 2
ffmpeg -threads $THREADS -y -i stream.dump -s 480x272 -vcodec libx264 -b $BITRATE -flags +loop -cmp +chroma -me_range 16 -g 300 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -rc_eq "blurCplx^(1-qComp)" -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -coder 0 -refs 1 -bt $BITRATE -maxrate 4M -bufsize 4M -level 21  -r 30000/1001 -partitions +parti4x4+partp8x8+partb8x8 -me hex -subq 5 -f mp4 -aspect 480:270 -title "$TITLE" -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 410 "$TITLE.mp4"
if [ $? -eq 0 ]
then
   touch .CONVERTED-TO-IPHONE
fi
rm -f *log
rm -f *dump
