#!/usr/bin/env python

import sgmllib
import sys
import urllib
import os

class MyParser(sgmllib.SGMLParser):
    "A simple parser class."

    def parse(self, s):
        "Parse the given string 's'."
        self.feed(s)
        self.close()

    def __init__(self, verbose=0):
        "Initialise an object, passing 'verbose' to the superclass."

        sgmllib.SGMLParser.__init__(self, verbose)
        self.inRightTag = 0
        self.episodeData = []

    def start_a(self, attributes):
        "Process a tags and its 'attributes'."

        if attributes[0][0] == "class" and attributes[0][1] == "wlink" and attributes[1][0] == "href":
            self.inRightTag = 1
        #for name, value in attributes:
        #    if name == "class" and value == "wlink": 
        #        self.inRightTag = 1

    def end_a(self):
        "Close the a tags"

        self.inRightTag = 0

    def handle_data(self, data):
        "Handle the textual 'data'."

        if self.inRightTag == 1:
            self.episodeData.append(data)

    def get_episodeData(self):
        "Return the list of Episode Data."

        return self.episodeData

def parse_my_stuff(tvshow, season):
    # Get something to work with.
    f = urllib.urlopen("http://www.tvrage.com/%s/episode_guide/%s" % (str(tvshow), str(season)))
    s = f.read()
    myparser = MyParser()
    myparser.parse(s)
    #print myparser.get_episodeData()
    return myparser.get_episodeData()

def main():
    run = True
    if len(sys.argv) < 3:
        print "Not enough arguments"
        run = False
        #sys.exit(1)
    if run:
        tvshow = str(sys.argv[1]).replace(" ","_")
        season = sys.argv[2]
        list_of_stuff = parse_my_stuff(tvshow, season)
        for index in list_of_stuff:
            s_info = index.split(":")
            t_info = s_info[1].split("-")
            number = str(t_info[0]).strip()
            title = str(t_info[1]).strip().replace(" ","_")
            os.mkdir("./%s-%s-%s" % (str(tvshow), str(number), str(title)))

if __name__ == "__main__":
    main()
