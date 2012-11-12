# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($x, $y) = map { int rand 65536 } 0..1;
my $pt = cvPoint($x, $y);
is($pt->[0], $x);
is($pt->[1], $y);

SKIP: {
	skip "no T", 6 unless Cv->can('CvPoint');
	my $line;

	my $out = Cv::CvPoint($pt);
	is($out->[0], $pt->[0]);
	is($out->[1], $pt->[1]);

	$line = __LINE__ + 1;
	eval { Cv::CvPoint() };
	is($@, "Usage: Cv::CvPoint(pt) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint([]) };
	is($@, "Cv::CvPoint: pt is not of type CvPoint at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint([1]) };
	is($@, "Cv::CvPoint: pt is not of type CvPoint at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint(['x', 'y']) };
	is($@, "Cv::CvPoint: pt is not of type CvPoint at $0 line $line.\n");
}
