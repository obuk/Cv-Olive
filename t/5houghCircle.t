# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);

BEGIN {
	use_ok('Cv');
	use_ok('Cv::Seq::Circle');
}

my $verbose = Cv->hasGUI;

# my $filename = @ARGV > 0? shift : dirname($0).'/'."baboon.jpg";
# my $img = Cv->loadImage($filename, 1)
#	or die "$0: can't loadimage $filename\n";

my $img = Cv->createImage([320, 240], 8, 3)->zero;
$img->circle([120 + rand(80),  40 + rand(80)], 20 + rand(60),
			 cvScalarAll(200), 5);
$img->circle([200 + rand(80), 120 + rand(80)], 20 + rand(60),
			 cvScalarAll(200), 5);

# my $gray = $img->cvtColor(CV_BGR2GRAY)->smooth(CV_GAUSSIAN, 9, 9);
my $gray = $img->cvtColor(CV_BGR2GRAY)->smooth(CV_GAUSSIAN, 5, 5);

my $storage = Cv->createMemStorage;
my $circles = bless $gray->houghCircles(
	$storage, CV_HOUGH_GRADIENT, 2, $gray->height/4, 200, 100
	),	"Cv::Seq::Circle";

my @circles = $circles->toArray;
$img->circle($_->[0], 3, CV_RGB(0, 255, 0), 3) for @circles;
$img->circle($_->[0], $_->[1], CV_RGB(0, 255, 0), 3) for @circles;
if ($circles->total > 0) {
	my $circle = $circles->getSeqElem(0);
	my ($center, $radius) = $circles->getSeqElem(0);
	is($circle->[0]->[0], $center->[0]);
	is($circle->[0]->[1], $center->[1]);
	is($circle->[1], $radius);
}
ok($circles->total >= 1);

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

