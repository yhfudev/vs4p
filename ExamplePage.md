# Introduction #

Here I will show some examples of some of the scripts and the tools.

These are generally the same for the iPhone and the PSP scripts.

# Details #

To convert a avi format (xvid/dvix) of a movie into an mp4:

```
~]$ cd Transformers
~/Transformers]$ video-to-iphone.sh transformers.avi
```

To convert a avi format (xvid/dvix) of a movie into an mp4 with a higher bitrate:

```
~]$ cd Transformers
~/Transformers]$ video-to-iphone.sh -b 768k transformers.avi
```


To convert a avi format (xvid/dvix) of a TV show into an mp4:

```
~]$ cd Arrested_Development-02x13-Motherboy_XXX
~/Arrested_Development-02x13-Motherboy_XXX:]$ tv-to-iphone.sh ad2e13.avi
```

Here I have a directory full of Arrested Development season 2 videos that I have ripped from DVD.  I will first create the correct directories for them, then move them into directories, and then start the conversion on them:

```
~/season2]$ ls
Arrested Development - s02e01 - The One Where Michael Leaves.avi
Arrested Development - s02e02 - The One Where They Build a House.avi
Arrested Development - s02e03 - Amigos.avi
Arrested Development - s02e04 - Good Grief.avi
Arrested Development - s02e05 - Sad Sack.avi
Arrested Development - s02e06 - Afternoon Delight.avi
Arrested Development - s02e07 - Switch Hitter.avi
Arrested Development - s02e08 - Queen for a Day.avi
Arrested Development - s02e09 - Burning Love.avi
Arrested Development - s02e10 - Ready, Aim, Marry Me.avi
Arrested Development - s02e11 - Out on a Limb.avi
Arrested Development - s02e12 - My Hand to God.avi
Arrested Development - s02e13 - Motherboy XXX.avi
Arrested Development - s02e14 - The Immaculate Election.avi
Arrested Development - s02e15 - The Sword of Destiny.avi
Arrested Development - s02e16 - Meet the Veals.avi
Arrested Development - s02e17 - Spring Breakout.avi
Arrested Development - s02e18 - Righteous Brothers.avi
~/season2]$ make-tvdirs.py "Arrested Development" 2
~/season2]$ ls
Arrested_Development-02x01-The_One_Where_Michael_Leaves_(2)
Arrested_Development-02x02-The_One_Where_They_Build_a_House
Arrested_Development-02x03-Amigos
Arrested_Development-02x04-Good_Grief!
Arrested_Development-02x05-Sad_Sack
Arrested_Development-02x06-Afternoon_Delight
Arrested_Development-02x07-Switch_Hitter
Arrested_Development-02x08-Queen_for_a_Day
Arrested_Development-02x09-Burning_Love
Arrested_Development-02x10-Ready,_Aim,_Marry_Me
Arrested_Development-02x11-Out_on_a_Limb_(1)
Arrested_Development-02x12-My_Hand_to_God_(2)
Arrested_Development-02x13-Motherboy_XXX
Arrested_Development-02x14-The_Immaculate_Election
Arrested_Development-02x15-The_Sword_of_Destiny
Arrested_Development-02x16-Meet_the_Veals
Arrested_Development-02x17-Spring_Breakout
Arrested_Development-02x18-Righteous_Brothers
Arrested Development - s02e01 - The One Where Michael Leaves.avi
Arrested Development - s02e02 - The One Where They Build a House.avi
Arrested Development - s02e03 - Amigos.avi
Arrested Development - s02e04 - Good Grief.avi
Arrested Development - s02e05 - Sad Sack.avi
Arrested Development - s02e06 - Afternoon Delight.avi
Arrested Development - s02e07 - Switch Hitter.avi
Arrested Development - s02e08 - Queen for a Day.avi
Arrested Development - s02e09 - Burning Love.avi
Arrested Development - s02e10 - Ready, Aim, Marry Me.avi
Arrested Development - s02e11 - Out on a Limb.avi
Arrested Development - s02e12 - My Hand to God.avi
Arrested Development - s02e13 - Motherboy XXX.avi
Arrested Development - s02e14 - The Immaculate Election.avi
Arrested Development - s02e15 - The Sword of Destiny.avi
Arrested Development - s02e16 - Meet the Veals.avi
Arrested Development - s02e17 - Spring Breakout.avi
Arrested Development - s02e18 - Righteous Brothers.avi
~/season2]$ for i in $(seq -w 18); do mv *e$i*avi *x$i*; done
/season2]$ ls -R
./Arrested_Development-02x01-The_One_Where_Michael_Leaves_(2):
Arrested Development - s02e01 - The One Where Michael Leaves.avi

./Arrested_Development-02x02-The_One_Where_They_Build_a_House:
Arrested Development - s02e02 - The One Where They Build a House.avi

./Arrested_Development-02x03-Amigos:
Arrested Development - s02e03 - Amigos.avi

./Arrested_Development-02x04-Good_Grief!:
Arrested Development - s02e04 - Good Grief.avi

./Arrested_Development-02x05-Sad_Sack:
Arrested Development - s02e05 - Sad Sack.avi

./Arrested_Development-02x06-Afternoon_Delight:
Arrested Development - s02e06 - Afternoon Delight.avi

./Arrested_Development-02x07-Switch_Hitter:
Arrested Development - s02e07 - Switch Hitter.avi

./Arrested_Development-02x08-Queen_for_a_Day:
Arrested Development - s02e08 - Queen for a Day.avi

./Arrested_Development-02x09-Burning_Love:
Arrested Development - s02e09 - Burning Love.avi

./Arrested_Development-02x10-Ready,_Aim,_Marry_Me:
Arrested Development - s02e10 - Ready, Aim, Marry Me.avi

./Arrested_Development-02x11-Out_on_a_Limb_(1):
Arrested Development - s02e11 - Out on a Limb.avi

./Arrested_Development-02x12-My_Hand_to_God_(2):
Arrested Development - s02e12 - My Hand to God.avi

./Arrested_Development-02x13-Motherboy_XXX:
Arrested Development - s02e13 - Motherboy XXX.avi

./Arrested_Development-02x14-The_Immaculate_Election:
Arrested Development - s02e14 - The Immaculate Election.avi

./Arrested_Development-02x15-The_Sword_of_Destiny:
Arrested Development - s02e15 - The Sword of Destiny.avi

./Arrested_Development-02x16-Meet_the_Veals:
Arrested Development - s02e16 - Meet the Veals.avi

./Arrested_Development-02x17-Spring_Breakout:
Arrested Development - s02e17 - Spring Breakout.avi

./Arrested_Development-02x18-Righteous_Brothers:
Arrested Development - s02e18 - Righteous Brothers.avi
~/season2]$ convert-tvdir-to-iphone.sh
```