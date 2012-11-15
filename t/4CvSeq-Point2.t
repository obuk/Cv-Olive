# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 127;

BEGIN {
	use_ok('Cv');
}

use File::Basename;
my $pic1 = dirname($0) . "/pic1.png";
my $verbose = Cv->hasGUI;

my $src = Cv->LoadImage($pic1, 0)
    or die "$0: can't loadimage $pic1\n";

# my $dst = $src->new($src->sizes, CV_8UC1);
my $storage = Cv::MemStorage->new;

my $dst = $src->Canny(50, 200, 3);
my $color = $dst->CvtColor(CV_GRAY2BGR);

my $lines = bless $dst->HoughLines2(
	$storage, CV_HOUGH_PROBABILISTIC, 1, &CV_PI / 180, 50, 50, 10,
	), 'Cv::Seq::Point2';
$color->Line($_->[0], $_->[1], CV_RGB(255, 0, 0), 3, CV_AA, 0)
	for @$lines;

my @lines;
while (my $pt2 = $lines->shift) {
	push(@lines, $pt2);
}
is(scalar @$lines, 0);
$lines->push($_) for @lines;
is(scalar @$lines, scalar @lines);


if ($verbose) {
	Cv->NamedWindow("Source", 1);
	$src->ShowImage("Source");
	Cv->NamedWindow("Hough", 1);
	$color->ShowImage("Hough");
	Cv->WaitKey(1000);
}
