# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($width, $height) = map { int rand 16384 } 0..1;

my $size = Cv::cvSize($width, $height);
is($size->[0], $width);
is($size->[1], $height);

SKIP: {
	skip "no T", 6 unless Cv->can('CvSize');
	my $line;

	my $out = Cv::CvSize($size);
	is($out->[$_], $size->[$_]) for 0 .. 1;

	$line = __LINE__ + 1;
	eval { Cv::CvSize() };
	is($@, "Usage: Cv::CvSize(size) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvSize([]) };
	is($@, "Cv::CvSize: size is not of type CvSize at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvSize(['x', $height]) };
	is($@, "Cv::CvSize: size is not of type CvSize at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvSize([$width, 'x']) };
	is($@, "Cv::CvSize: size is not of type CvSize at $0 line $line.\n");

}
