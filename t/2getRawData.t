# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 35;
BEGIN { use_ok('Cv', -nomore) }

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

	if ($mat->isa('Cv::Image')) {
		my ($y0, $x0) = ($rows/4, $cols/4);
		my ($rows2, $cols2) = ($rows/2, $cols/2);
		my $step2 = $cols * $cn;
		$mat->setImageROI([ $x0, $y0, $cols2, $rows2 ]);
		$mat->fill(cvScalarAll(45));
		$mat->getRawData(my $rawData2, my $rawStep2, my $rawSize2);
		is($rawStep2, $step2);
		is_deeply($rawSize2, [$cols2, $rows2]);
		is(length($rawData2), $step2 * $rows2);
		is(ord(substr($rawData2, 0, 1)), 45);
		$mat->resetImageROI();
	}

	# SvREADONLY_on
  SKIP: {
	  skip "Test::Exception required", 1 unless eval "use Test::Exception";
	  throws_ok { substr($rawData, 0, 1) = 'x'; } qr/Modification of a read-only value attempted at $0/;
	}
}


SKIP: {
	skip "Test::Exception required", 1 unless eval "use Test::Exception";
	my $class = qw(Cv::SparseMat);
	my $mat = $class->new([320, 240], CV_8UC3);
	throws_ok { $mat->getRawData(my $rawData, my $rawStep, my $rawSize) } qr/OpenCV Error:/;
}
