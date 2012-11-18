# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 15;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($x, $y, $z) = map { (int rand 16384) + 0.5 } 0..2;

SKIP: {
	skip "no T", 14 unless Cv->can('CvPoint3D64fPtr');
	my $line;

	my $arr = Cv::cvPoint3D64fPtr($x, $y, $z);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);

	my $pt = $arr->[0];
	is($pt->[0], $x);
	is($pt->[1], $y);
	is($pt->[2], $z);

	my $out = Cv::CvPoint3D64fPtr($pt);
	is($out->[0]->[0], $pt->[0]);
	is($out->[0]->[1], $pt->[1]);
	is($out->[0]->[2], $pt->[2]);

	$line = __LINE__ + 1;
	eval { Cv::CvPoint3D64fPtr() };
	is($@, "Usage: Cv::CvPoint3D64fPtr(pt) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint3D64fPtr([]) };
	is($@, "Cv::CvPoint3D64fPtr: pt is not of type CvPoint3D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint3D64fPtr([1]) };
	is($@, "Cv::CvPoint3D64fPtr: pt is not of type CvPoint3D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint3D64fPtr([1, 2]) };
	is($@, "Cv::CvPoint3D64fPtr: pt is not of type CvPoint3D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint3D64fPtr(['x', 'y']) };
	is($@, "Cv::CvPoint3D64fPtr: pt is not of type CvPoint3D64f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint3D64fPtr(['1x', '2y', '3z']) };
	is($@, "");
}
