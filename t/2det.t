# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 5;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
#  double cvDet(const CvArr* mat)
# ------------------------------------------------------------

if (1) {
	my $src = Cv::Mat->new([2, 2], CV_32FC1);
	$src->set([0, 0], [1]);
	$src->set([0, 1], [2]);
	$src->set([1, 0], [3]);
	$src->set([1, 1], [4]);
	my $det = $src->det;
	is($det, -2);
}

if (2) {
	my $src = Cv::Mat->new([2, 2], CV_64FC1);
	$src->set([0, 0], [2]);
	$src->set([0, 1], [1]);
	$src->set([1, 0], [3]);
	$src->set([1, 1], [4]);
	my $det = $src->det;
	is($det, 5);
}

if (10) {
	my $src = Cv::Mat->new([2], CV_32FC1);
	e { $src->det(1) };
	err_is("Usage: Cv::Arr::cvDet(mat)");
}

if (11) {
	my $src = Cv::Mat->new([2], CV_32FC1);
	e { $src->det };
	err_like("OpenCV Error");
}
