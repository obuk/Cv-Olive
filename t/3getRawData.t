# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

# SvREADONLY_on
# Cv::Mat->getRawData

if (1) {
	my $rows = 240;
	my $cols = 320;
	my $cn = 3;
	my $step = $cols * $cn;
	my $type = CV_MAKETYPE(CV_8U, $cn);
	my $mat = Cv::Mat->new([$rows, $cols], $type)->fill(cvScalarAll(123));
	$mat->getRawData(my $rawData, my $rawStep, my $rawSize);
	is($rawStep, $step);
	is($rawSize->[0], $cols);
	is($rawSize->[1], $rows);
	is(length($rawData), $step * $rows);
	is(ord(substr($rawData, 0, 1)), 123);
	eval { substr($rawData, 0, 1) = 'x'; };
	like($@, qr/Modification of a read-only value attempted at/);
}


# Cv::Image->getRawData

if (2) {
	my $rows = 240;
	my $cols = 320;
	my $cn = 3;
	my $step = $cols * $cn;
	my $type = CV_MAKETYPE(CV_8U, $cn);
	my $mat = Cv::Image->new([$rows, $cols], $type)->fill(cvScalarAll(123));
	$mat->getRawData(my $rawData, my $rawStep, my $rawSize);
	is($rawStep, $step);
	is($rawSize->[0], $cols);
	is($rawSize->[1], $rows);
	is(length($rawData), $step * $rows);
	is(ord(substr($rawData, 0, 1)), 123);
	eval { substr($rawData, 0, 1) = 'x'; };
	like($@, qr/Modification of a read-only value attempted at/);
}
