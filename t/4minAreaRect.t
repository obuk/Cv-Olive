# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 4;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv') }

my $verbose = Cv->hasGUI;

my $img = Cv::Mat->new([300, 300], CV_8UC3);
my @points = ([ 100, 100 ], [ 200, 100 ], [ 200, 200 ], [ 100, 200 ]);

if (1) {
	my @vtx = Cv->boxPoints(Cv->MinAreaRect(@points));
	is_deeply({ round => '%.0f', rotate => 1 }, \@vtx, \@points);
	if ($verbose) {
		$img->zero;
		$img->circle($_, 3, cvScalar(0, 0, 255), CV_FILLED, CV_AA) for @points;
		$img->polyLine([ \@vtx ], 1, cvScalar(0, 255, 0), 1, CV_AA);
		$img->show("rect & circle");
		Cv->waitKey(1000);
	}
}

if (2) {
	my @vtx = Cv->boxPoints(Cv->MinAreaRect(\@points));
	is_deeply({ round => '%.0f', rotate => 1 }, \@vtx, \@points);
}
