# Introduction to some tools #

These are some tools to help with converting videos.

I have create and ExamplePage to show intended use of these tools.

# Details #

## convert-tvdir-to-iphone.sh ##

This is a quick script that will go into each sub directory within the current directory and convert the avi file into an mp4 for the iphone.  This uses tv-to-iphone.sh to do the converting.  This comes in handy if you have a directory of tv shows that you would like to convert.

Whenever tv-to-iphone.sh completes successfully, it will create a file in the directory called ".CONVERTED-TO-IPHONE."  If this file exists, the script will skip over that directory.  This will come in handy so that you won't re-encode the same video more than once.  This way convert-tvdir-to-iphone.sh can be run in the same directory more than once, and only encode new videos.


## make-tvdirs.py ##

This is a quick python script that goes out and scrapes tvrage.com.  This script takes two arguments, the first being the TV show, the second being the season number.  If the TV show has more than one word, put the TV show in quotes.  This will then fetch the information for that particular season, and then create directories in the expected format.

If you are having trouble finding your TV show, go to TV rage and find bring up the URL for that particular show and season.  Here is the URL for the 10 season for The Office:

http://www.tvrage.com/The_Office/episode_guide/3

Pass in the name of the tv show as it appears after the ".com/." In this example, it is "The Office" You can use spaces or underscores.