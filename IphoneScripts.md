# Introduction to iPhone Scripts #

Here is some information about of the scripts related to the iPhone.


# Details #

## tv-to-iphone.sh ##

This is the script I've been writing and maintaining lately.  This script takes video file  as the command line argument, and will then convert it over.  I pull the TV show information (show name, season, episode, episode title) from the parent directory, and the format has to be how I have it set up.  I have written a little utility that goes out and creates directories in the correct format for a given show.  See the ToolPage for details.

The format of the parent directory should be:

The\_Office-1x01-Pilot\_Episode

Then inside of this directory should be the original video file.  A basic structure would look like this:

The\_Office-1x01-Pilot\_Episode
> \office-pilot-episode.avi

Spaces should work in light of the underscores (_).  This uses ffmpeg and AtomicParsely to do the backend encoding and tagging._

To run the script (assuming all other programs are installed correctly):

_~/The\_Office-1x01-Pilot\_Episode$ tv-to-iphone.sh office-pilot-episode.avi_

## video-to-iphone.sh ##

This is a script that is general purpose script.  It takes a video file as an argument, and then converts it over into the iPhone format.  Again, this uses the parent directory as the place to gather the title of the video and that is what is set inside the meta data of the given mp4.

The only difference between video-to-iphone.sh and tv-to-iphone.sh is that AtomicParsley won't be used to set the meta data and will not tag this as a "TV Show."

## dvd-to-iphone.sh ##

This script takes a DVD iso/img file as an argument and attempts to convert it into a video watchable on the iPhone.  I use mplayer to dump the video out, of the DVD, and then use ffmpeg to convert it from the ripped source into the mp4.  mplayer has shown issues here and does not always dump the DVD stream from the DVD image file.  It tries to locate a stereo track on the DVD (as opposed to 5.1.)  I've had about 85% success rate with this script.  It's still a work in progress.