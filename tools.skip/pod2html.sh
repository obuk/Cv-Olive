#!/bin/sh -x
LANG=ja_JP.UTF-8; export LANG
destdir=$HOME/public_html/Cv
test -d $destdir || mkdir $destdir
pod2html lib/Cv.pm >$destdir/Cv.html
pod2html lib/Cv/Nihongo.pod >$destdir/Nihongo.html 
