# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 13;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

my $src = Cv->createImage([320, 240], 8, 3);

if (1) {
	is($src->width, 320);
	is($src->height, 240);
}

if (2) {
	my $sizes = $src->sizes;
	is($sizes->[0], $src->height);
	is($sizes->[1], $src->width);
}

if (3) {
	my $size = $src->getSize;
	is($size->[0], $src->width);
	is($size->[1], $src->height);
}

if (4) {
	my $size = $src->size;
	is($size->[0], $src->width);
	is($size->[1], $src->height);
}

if (10) {
	e { Cv::Arr::cvSize };
	err_is('Usage: Cv::Arr::cvSize(arr)');
	e { Cv::Arr::cvGetSize };
	err_is('Usage: Cv::Arr::cvGetSize(arr)');
}

if (11) {
	e { Cv::Arr::cvGetSize(1) };
	err_is('arr is not of type CvArr * in Cv::Arr::cvGetSize');
}
