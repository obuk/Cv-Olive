# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($x, $y) = map { (int rand 16384) + 0.5 } 0..1;
my $pt = cvPoint2D64f($x, $y);
is($pt->[0], $x);
is($pt->[1], $y);

SKIP: {
	skip "no T", 6 unless Cv->can('CvPoint2D64f');
	my $line;

	my $out = Cv::CvPoint2D64f($pt);
	is($out->[0], $pt->[0]);
	is($out->[1], $pt->[1]);

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64f() };
	is($@, "Usage: Cv::CvPoint2D64f(pt) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64f([]) };
	is($@, "Cv::CvPoint2D64f: pt is not of type CvPoint2D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64f([1]) };
	is($@, "Cv::CvPoint2D64f: pt is not of type CvPoint2D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64f(['1x', '2y']) };
	is($@, "");
}
