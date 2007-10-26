#!/bin/sh

if [ $# -lt 1 ]; then
   echo "usage: $(basename $0) <videofile>"
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
   shift $(($OPTIND - 1))
done

if [ -z "$BITRATE" ] 
then
   BITRATE=300k
fi

if [ -z "$THREADS" ] 
then
   THREADS=$(grep -c "^processor" /proc/cpuinfo)
fi



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
ffmpeg -threads $THREADS -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b $BITRATE -pass 1 -f psp $NAME.MP4
ffmpeg -threads $THREADS -y -i "$1" -title $TITLE -vcodec libx264 -coder 1 -bufsize 128 -g 250 -s 480x272 -r 29.97 -b $BITRATE -pass 2 -acodec libfaac -ac 2 -ar 48000 -ab 128 -vol 384 -f psp $NAME.MP4
if [ $? -eq 0 ]
then
   #Picture
   cat $1 | ffmpeg -y -i - -f image2 -ss 30 -vframes 1 -s 160x120 -an $NAME.THM
   touch .CONVERTED-TO-PSP
fi
rm -f *log
rm -f *dump
