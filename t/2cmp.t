# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -nomore) }

# ------------------------------------------------------------
#  void cvCmp(const CvArr* src1, const CvArr* src2, CvArr* dst, int cmpOp)
#  void cvCmpS(const CvArr* src, double value, CvArr* dst, int cmpOp)
# ------------------------------------------------------------

if (1) {
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	$src->roi([0, 0, 10, 10]); $src->zero;
	$src->resetROI();
	my $c1 = $src->countNonZero;
	my $gt0 = $src->cmp(0, CV_CMP_GT);
	my $c2 = $gt0->countNonZero;
	is($c1, $c2);
}

if (2) {
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	$src->roi([0, 0, 10, 10]); $src->zero;
	$src->resetROI();
	my $src2 = $src->new->zero;
	my $c1 = $src->countNonZero;
	my $gt0 = $src->cmp($src2, CV_CMP_GT);
	my $c2 = $gt0->countNonZero;
	is($c1, $c2);
}

if (10) {
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	e { $src->cmp };
	err_is('Usage: Cv::Arr::cvCmpS(src, value, dst, cmpOp)');
}

if (11) {
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	e { $src->cmp(0, -1) };
	err_like('OpenCV Error:');
}

if (12) {
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	e { $src->cmp(Cv::Image->new([10, 10], CV_8UC1), CV_CMP_EQ) };
	err_like('OpenCV Error:');
}
