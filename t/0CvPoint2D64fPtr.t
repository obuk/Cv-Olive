# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN {	use_ok('Cv', -more) }

my ($x, $y) = map { (int rand 16384) + 0.5 } 0..1;

SKIP: {
	skip "no T", 10 unless Cv->can('CvPoint2D64fPtr');
	my $line;

	my $arr = Cv::cvPoint2D64fPtr($x, $y);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);

	my $pt = $arr->[0];
	is($pt->[0], $x);
	is($pt->[1], $y);

	my $out = Cv::CvPoint2D64fPtr($pt);
	is($out->[0]->[0], $pt->[0]);
	is($out->[0]->[1], $pt->[1]);

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64fPtr() };
	is($@, "Usage: Cv::CvPoint2D64fPtr(pt) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64fPtr([]) };
	is($@, "Cv::CvPoint2D64fPtr: pt is not of type CvPoint2D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64fPtr([1]) };
	is($@, "Cv::CvPoint2D64fPtr: pt is not of type CvPoint2D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint2D64fPtr(['1x', '2y']) };
	is($@, "");
}
