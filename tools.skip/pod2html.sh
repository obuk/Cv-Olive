#!/bin/sh
LANG=ja_JP.UTF-8; export LANG
poddir=$HOME/public_html/pod
pod2html="pod2html --htmlroot=/~obuk/pod"
for pm in `(cd lib; find . -name '*pm' -o -name '*pod')`; do
  destdir=`dirname $poddir/$pm`
  test -d $destdir || mkdirhier $destdir
  basename=`basename $poddir/$pm .pm`
  basename=`basename $basename .pod`
  html=$basename.html
  $pod2html --infile=lib/$pm --outfile=$destdir/$html
done
