# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 35;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
#  void cvGetRawData(CvArr* arr, SV* data, OUT int step, OUT CvSize roiSize)
# ------------------------------------------------------------

for my $class (qw(Cv::Mat Cv::MatND Cv::Image)) {
	my ($rows, $cols, $cn) = (240, 320, 3);
	my $step = $cols * $cn;
	my $type = CV_MAKETYPE(CV_8U, $cn);
	my $mat = $class->new([$rows, $cols], $type)->fill(cvScalarAll(123));

	$mat->getRawData(my $rawData, my $rawStep, my $rawSize);
	is($rawStep, $step);
	is_deeply($rawSize, [$cols, $rows]);
	is(length($rawData), $step * $rows);
	is(ord(substr($rawData, 0, 1)), 123);

	$mat->getRawData(my $rawData2, my $rawStep2 = 2, my $rawSize2 = 2);
	is($rawStep2, $step);
	is_deeply($rawSize2, [$cols, $rows]);
	is(length($rawData2), $step * $rows);
	is(ord(substr($rawData2, 0, 1)), 123);

	$mat->getRawData(my $rawData3);
	is(length($rawData3), $step * $rows);
	is(ord(substr($rawData3, 0, 1)), 123);

	# SvREADONLY_on
	e { substr($rawData, 0, 1) = 'x'; };
	err_is("Modification of a read-only value attempted");
}

if (10) {
	my $class = qw(Cv::SparseMat);
	my $mat = $class->new([320, 240], CV_8UC3);
	e { $mat->getRawData(my $rawData, my $rawStep, my $rawSize) };
	err_is('OpenCV Error: Bad argument (unrecognized or unsupported array type) in cvGetRawData', "$class->getRowData");
}
