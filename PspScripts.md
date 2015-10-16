# Introduction to PSP Scripts #

Here is some information about of the scripts related to the PSP.  The naming of the PSP files is a bit different than other files.  PSP's require that the name is in the form:

MAXXXXX.MP4
MAXXXXX.THM

Where the XXXXX are 5 numbers.  I have done a simple "algorithm" to create these numbers. My convention is the following:

For a video and dvd, I just do an MD5 sum of the Title (parent directory) and take the first 5 digits.

For TV shows, the following convention is used:

MAXXYZZ

  * X -- First 2 digits of an MD5SUM.  The thought behind this is that all TV Shows would start with the same 2 digits.
  * -- season number of the TV Show
  * Z -- episode number of the TV Show.


# Details #

## tv-to-psp.sh ##

This script takes video file  as the command line argument, and will then convert it over.  I pull the TV show information (show name, season, episode, episode title) from the parent directory, and the format has to be how I have it set up.  The format of the parent directory should be:

The\_Office-1x01-Pilot\_Episode

Then inside of this directory should be the original video file.  A basic structure would look like this:

The\_Office-1x01-Pilot\_Episode
> \office-pilot-episode.avi

Spaces should work in light of the underscores (_)._

To run the script (assuming all other programs are installed correctly):

_~/The\_Office-1x01-Pilot\_Episode$ tv-to-psp.sh office-pilot-episode.avi_

## xvid-to-iphone.sh ##

This is a script that is general purpose script.  It takes a video file as an argument, and then converts it over into the PSP format.  Again, this uses the parent directory as the place to gather the title of the video and that is what is set inside the meta data of the given mp4.

## dvd-to-psp.sh ##

This script takes a DVD iso/img file as an argument and attempts to convert it into a video watchable on the PSP.  I use mplayer to dump the video out, of the DVD, and then use ffmpeg to convert it from the dumped source into the mp4.  mplayer has shown issues here and does not always dump the DVD stream from the DVD image file.  It tries to locate a stereo track on the DVD (as opposed to 5.1.)  I've had about 85% success rate with this script.  It's still a work in progress.