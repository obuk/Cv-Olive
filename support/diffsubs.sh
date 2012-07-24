#!/bin/sh
cwd=`pwd`
# left=Cv-0.12
left=Cv-0.13
right=Cv-Olive
for cv in $left $right; do
    (cd ../$cv; $cwd/support/listsubs.pl) |sort >$cv.tmp
done
diff -W 80 -y $left.tmp $right.tmp
