# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 27;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my @val = map { (int rand 16384) + 0.5 } 0..3;

my $scalar1 = Cv::cvScalar($val[0]);
is($scalar1->[$_], $val[$_]) for 0;
is($scalar1->[$_], 0) for 1 .. 3;

my $scalar2 = Cv::cvScalar(@val[0 .. 1]);
is($scalar2->[$_], $val[$_]) for 0 .. 1;
is($scalar2->[$_], 0) for 2 .. 3;

my $scalar3 = Cv::cvScalar(@val[0 .. 2]);
is($scalar3->[$_], $val[$_]) for 0 .. 2;
is($scalar3->[$_], 0) for 3;

my $scalar = Cv::cvScalar(@val);
is($scalar->[$_], $val[$_]) for 0 .. 3;

SKIP: {
	skip "no T", 10 unless Cv->can('CvScalar');
	my $line;

	my $out = Cv::CvScalar($scalar);
	is($out->[$_], $scalar->[$_]) for 0 .. 3;

	$line = __LINE__ + 1;
	eval { Cv::cvScalar() };
	is($@, "Usage: Cv::cvScalar(val0, val1=0, val2=0, val3=0) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvScalar() };
	is($@, "Usage: Cv::CvScalar(scalar) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvScalar(['1x', $val[1], $val[2], $val[3]]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvScalar([$val[0], '2x', $val[2], $val[3]]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvScalar([$val[0], $val[1], '3x', $val[3]]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvScalar([$val[0], $val[1], $val[2], '4x']) };
	is($@, "");

}
