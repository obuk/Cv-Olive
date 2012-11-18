# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($width, $height) = map { (int rand 16384) + 0.5 } 0..1;

my $size2D32f = Cv::cvSize2D32f($width, $height);
is($size2D32f->[0], $width);
is($size2D32f->[1], $height);

SKIP: {
	skip "no T", 6 unless Cv->can('CvSize2D32f');
	my $line;

	my $out = Cv::CvSize2D32f($size2D32f);
	is($out->[$_], $size2D32f->[$_]) for 0 .. 1;

	$line = __LINE__ + 1;
	eval { Cv::CvSize2D32f() };
	is($@, "Usage: Cv::CvSize2D32f(size) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvSize2D32f([]) };
	is($@, "Cv::CvSize2D32f: size is not of type CvSize2D32f at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvSize2D32f(['1x', $height]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvSize2D32f([$width, '1x']) };
	is($@, "");

}
