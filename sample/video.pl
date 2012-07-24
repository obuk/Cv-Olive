#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);

use Cv;

Cv->namedWindow('Cv', 0);
my $cap = Cv->captureFromCAM(0);
my $fourcc = CV_FOURCC('M', 'J', 'P', 'G');
my $video = Cv->createVideoWriter("sample.avi", $fourcc, 10, [ 320, 240 ]);
while (my $frame = $cap->queryFrame) {
    $frame->flip(\0, 1)->show('Cv');
    my $c = Cv->waitKey(100);
    $c &= 0x7f if ($c >= 0);
    last if ($c == 27);
    $video->writeFrame($frame);
}
