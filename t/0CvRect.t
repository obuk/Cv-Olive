# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 15;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($x, $y, $width, $height) = map { int rand 16384 } 0..3;

my $rect = Cv::cvRect($x, $y, $width, $height);
is($rect->[0], $x);
is($rect->[1], $y);
is($rect->[2], $width);
is($rect->[3], $height);

SKIP: {
	skip "no T", 10 unless Cv->can('CvRect');
	my $line;

	my $out = Cv::CvRect($rect);
	is($out->[$_], $rect->[$_]) for 0 .. 3;

	$line = __LINE__ + 1;
	eval { Cv::CvRect() };
	is($@, "Usage: Cv::CvRect(rect) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvRect([]) };
	is($@, "Cv::CvRect: rect is not of type CvRect at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvRect(['1x', $y, $width, $height]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvRect([$x, '2x', $width, $height]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvRect([$x, $y, '3x', $height]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvRect([$x, $y, $width, '4x']) };
	is($@, "");

}
