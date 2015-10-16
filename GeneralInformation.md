# Introduction #

This project creates scripts that will re-encode videos from xvid (or anything ffmpeg recognizes) to h264 encoded videos from the Linux command line that are able to play on the PSP or the iPhone.  Here is how the project came to be:

I am a gadget geek.  I have all kinds of different gadgets, but a couple of my favorite ones lately have been the PSP and the iPhone.  I've really enjoyed messing around with these.

I am also into videos, all types of videos.  These videos include DVD movies, movies in xvid/dvix format, tv shows and all other things that I can watch on my computer.

And one more thing I really enjoy is Linux.  I really like try to harness the power of the command line in Linux and take full advantage of it.

So, I guess as a natural progression, I have decided to try to combine these three things into my first Google Code project.  What I have done is tried to create some scripts that use the power of Linux, ffmpeg, AtomicParsley, and combine them to make some command line scripts that convert videos, (anything that ffmpeg recognizes) and converts it into video I can watch on both my PSP and iPhone.  These scripts aren't that complicated, but I do find them very useful.

I know there are many programs out there that will convert videos to the iPhone and PSP, but I couldn't find one that was simple and would do it from the command line.  I tend to keeps all of my storage on a Linux machine with all sorts of storage.  Since the videos are there, I like to convert them there as well.  I find that with some simple scripts, I can automate the conversion of these videos in a very convenient manner.  I have some friends who find them useful as well, so I decided to put them here for anyone that would like to use them.


# Details #

My scripts that I have written are very simple. I use ffmpeg on the back end, I use AtomicParsley to write the mp4 tags (for iPhone tags, PSP doesn't really use tags as much), and I use mplayer to convert my DVD ISO files into a raw stream that ffmpeg can use.  I am always looking for better ways to optimize these scripts, and I am always open to new ideas on how to do things.

I do plan on updating the scripts as I can.  Here is a rundown on the different components and scripts:

BackEndApps - This page talks about ffmpeg, AtomicParsley, and other apps that I use

## Setting Meta Data ##

mp4 files have the option to set quite a bit of meta data.  I have thought about where the best way to get this meta data from.  I thought about nfo files, but have found there is no consistent way to get information from these files.  I have thought about file name, and again, just no consistent way.

What I have decided to do is to use the parent directory of where the video file resides.  So, when I rip DVD's from my collection, I will put the ripped video file into a directory with the name of the show.  For example:

```
$ ls -R Transformers/
Transformers/:
transformers.avi
```

In this example, the directory name "Transformers" is going to be set as the title in the metadata of the mp4.

TV Shows also use the parent directory, but becuase there is more information needed for a TV show (show name, season, episode number, show title), I use the format like:

TV\_Show-3x10-Title\_of\_TV\_Show

In this example:
  * TV Show" would be set as the name of the show
  * 3" would be set as the season number
  * 10" would be set as the episode number
  * Title Of TV Show" would be set as the episode name

I have written a script to generate directories with this format.  More info can be found on the ToolPage.


## Options and Variables ##

The Scripts all do a 2 pass encoding with ffmpeg.

Currently, all of my scripts have some command line options that can be used.  A list is here:

  * -t -- number of threads ffmpeg should use.  This will speed up ffmpeg on mulit core cpu systems.

If the threads aren't specified, the scripts will attempt to guess how many cpus the computer has, both virtual and physical (read /proc/cpuinfo) and then insert that number of threads into the program.

  * -b -- bitrate the mp4 will be encoded in. **NOTE: The "k" is needed!**
This is, of course, directly related to the size of the mp4 that is being created.  I have found that it is possible to create a watchable 20 minute TV show at about 250k that takes up between 35-40MB of disk space.  ffmpeg doesn't reduce it much more than about 200k, and I wouldn't go over 1000k because I don't believe the quality trade-off is worth the size increase.  The default for TV is set at 300k, for video 400k, and dvd is 500k.


## Scripts ##

IphoneScripts  -- Information page about the iPhone scripts

PspScripts -- Information page about the PSP Scripts

ToolPage -- Information about some of the tools that come in handy