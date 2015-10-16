# Introduction #

This page describes the apps that I use on the backend of the script.  Make sure that these programs are in your PATH.

# Details #

## ffmpeg ##

I use ffmpeg to do all of the "heavy-lifting," or video converting.   The key is to have lib264 compiled into ffmpeg.

I used Ubuntu, Debian, and Suse, and I have only found decent packages for Debian. (These are found on the three-dimensional.net web site.  Google search will probably come up with them).  On Ubuntu,  I have followed various links in the Ubuntu forums to get them to work properly.

I have a new fresh install box installed with Ubuntu.  I am taking notes on what I did to get ffmpeg installed and running for vs4p:

I am following this link [here](http://ubuntuforums.org/showthread.php?t=786095) (from Ubuntu Forums)

1. Install needed packages:
```
sudo aptitude install build-essential subversion git-core zlib1g-dev checkinstall libgpac-dev libfaad-dev libfaac-dev liblame-dev libtheora-dev libvorbis-dev gpac liba52-dev libgsm1-dev libxvidcore4-dev 
```

2. Install yasm:
```
cd ~
wget http://www.tortall.net/projects/yasm/releases/yasm-0.7.1.tar.gz
tar xzvf yasm-0.7.1.tar.gz
cd yasm-0.7.1
./configure
make
sudo checkinstall
```

3. Get latest libx264:
```
cd ~/
git clone git://git.videolan.org/x264.git
cd x264
./configure --enable-pthread --enable-mp4-output --enable-shared
make
sudo checkinstall
```

4.  Update the links to the shared libraries created by x264:
```
sudo ldconfig
```

5. Get newest ffmpeg:
```
cd ~/
svn checkout svn://svn.mplayerhq.hu/ffmpeg/trunk ffmpeg
cd ffmpeg

./configure --prefix=/usr/local --libdir=${prefix}/lib --shlibdir=${prefix}/lib  --enable-shared --enable-libmp3lame --enable-gpl --enable-libfaad --mandir=${prefix}/share/man --enable-libvorbis --enable-pthreads --enable-libfaac --enable-libxvid --enable-x11grab  --enable-libgsm --enable-libx264 --enable-libtheora --enable-nonfree

make
sudo checkinstall
```


Check with the link to Ubuntu Forums for questions regarding updating and configuring ffmpeg on Ubuntu.


## AtomicParsley ##

[AtomicParsley home page](http://atomicparsley.sourceforge.net/)

AtomicParsley is a very nice little program that creates metadata for mp4 files.  This meta data is used by iTunes and by the iPhone.  I try to set the correct meta data using AtomicParsley.

Ubuntu now has Atomic Parsely in it's repo.  On Ubuntu 8.04, run:

_# apt-get install atomicparsley_