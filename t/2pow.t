# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

# ------------------------------------------------------------
#  void cvPow(const CvArr* src, CvArr* dst, double power)
# ------------------------------------------------------------

my $src = Cv::Mat->new([3], CV_32FC1);
$src->set([0], [rand 3]);
$src->set([1], [rand 3]);
$src->set([2], [rand 3]);

if (1) {
	my $dst = $src->pow(2);
	is_({ round => "%.4g" }, $dst->getReal(0), pow2($src->getReal(0)));
	is_({ round => "%.4g" }, $dst->getReal(1), pow2($src->getReal(1)));
	is_({ round => "%.4g" }, $dst->getReal(2), pow2($src->getReal(2)));
}

if (2) {
	$src->pow(my $dst = $src->new, 2);
	is_({ round => "%.4g" }, $dst->getReal(0), pow2($src->getReal(0)));
	is_({ round => "%.4g" }, $dst->getReal(1), pow2($src->getReal(1)));
	is_({ round => "%.4g" }, $dst->getReal(2), pow2($src->getReal(2)));
}

if (10) {
	e { $src->pow() };
	err_is("Usage: Cv::Arr::cvPow(src, dst, power)");
}

sub pow2 {
	my $x = shift;
	$x * $x;
}
