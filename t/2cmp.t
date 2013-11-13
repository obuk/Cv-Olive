# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 6;
BEGIN { use_ok('Cv', -nomore) }

# ------------------------------------------------------------
#  void cvCmp(const CvArr* src1, const CvArr* src2, CvArr* dst, int cmpOp)
#  void cvCmpS(const CvArr* src, double value, CvArr* dst, int cmpOp)
# ------------------------------------------------------------

{
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	$src->roi([0, 0, 10, 10]); $src->zero;
	$src->resetROI();
	my $c1 = $src->countNonZero;
	my $gt0 = $src->cmp(0, CV_CMP_GT);
	my $c2 = $gt0->countNonZero;
	is($c1, $c2);
}

{
	my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
	$src->roi([0, 0, 10, 10]); $src->zero;
	$src->resetROI();
	my $src2 = $src->new->zero;
	my $c1 = $src->countNonZero;
	my $gt0 = $src->cmp($src2, CV_CMP_GT);
	my $c2 = $gt0->countNonZero;
	is($c1, $c2);
}


SKIP: {
	skip "Test::Exception required", 3 unless eval "use Test::Exception";

	{
		my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
		throws_ok { $src->cmp } qr/Usage: Cv::Arr::cvCmpS\(src, value, dst, cmpOp\) at $0/;
	}

	{
		my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
		throws_ok { $src->cmp(0, -1) } qr/OpenCV Error:/;
	}

	{
		my $src = Cv::Image->new([100, 100], CV_8UC1)->fill([1]);
		throws_ok { $src->cmp(Cv::Image->new([10, 10], CV_8UC1), CV_CMP_EQ) } qr/OpenCV Error:/;
	}
}
