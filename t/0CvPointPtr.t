# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($x, $y) = map { int rand 65536 } 0..1;

SKIP: {
	skip "no T", 10 unless Cv->can('CvPointPtr');
	my $line;

	my $arr = Cv::cvPointPtr($x, $y);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);

	my $pt = $arr->[0];
	is($pt->[0], $x);
	is($pt->[1], $y);

	my $out = Cv::CvPointPtr($pt);
	is($out->[0], $pt->[0]);
	is($out->[1], $pt->[1]);

	$line = __LINE__ + 1;
	eval { Cv::CvPointPtr() };
	is($@, "Usage: Cv::CvPointPtr(pt) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPointPtr([]) };
	is($@, "Cv::CvPointPtr: pt is not of type CvPoint at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPointPtr([1]) };
	is($@, "Cv::CvPointPtr: pt is not of type CvPoint at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPointPtr(['x', 'y']) };
	is($@, "Cv::CvPointPtr: pt is not of type CvPoint at $0 line $line.\n");
}
