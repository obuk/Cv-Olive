# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 10;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv') }

my $verbose = Cv->hasGUI;

my $img = Cv->createImage([320, 240], 8, 3)->zero;
$img->circle([ 60 + rand(80), 80 + rand(80)], 30 + rand(30),
			 cvScalarAll(200), 5, CV_AA);
$img->circle([260 - rand(80), 80 + rand(80)], 30 + rand(30),
			 cvScalarAll(200), 5, CV_AA);

my $gray = $img->cvtColor(CV_BGR2GRAY)->smooth(CV_GAUSSIAN, 5, 5);
my $storage = Cv->createMemStorage;
my $circles = bless $gray->houghCircles(
	$storage, CV_HOUGH_GRADIENT, 1, 30, 100, 50, 25, 65), "Cv::Seq::Circle";
can_ok($circles, 'total');

for ($circles->toArray) {
	my $color = [ map { 64 + rand 192 } 1..3 ];
	$img->circle($_->[0], 3, $color, 3, CV_AA);
	$img->circle($_->[0], $_->[1], $color, 3, CV_AA);
}
if ($circles->total > 0) {
	my $circle = $circles->getSeqElem(0);
	my ($center, $radius) = $circles->getSeqElem(0);
	is($circle->[0]->[0], $center->[0]);
	is($circle->[0]->[1], $center->[1]);
	is($circle->[1], $radius);
}

is($circles->total, 2);

$circles->push(my $x = [[10, 20], 30]);
my $y = $circles->pop();
is($x->[0]->[0], $y->[0]->[0]);
is($x->[0]->[1], $y->[0]->[1]);
is($x->[1], $y->[1]);

if ($verbose) {
	Cv->namedWindow("Circles", 1);
	$img->showImage("Circles");
	Cv->WaitKey(1000);
}

