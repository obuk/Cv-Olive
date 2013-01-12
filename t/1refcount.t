# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 35;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

if (1) {
	my $mat = cvCreateMat(10, 10, CV_32FC1);
	ok($mat);
	is(ref $mat, 'Cv::Mat');
	is($mat->refcount, 1);
	Cv::Mat::cvReleaseMat($mat);
	is(ref $mat, 'SCALAR');
	e { Cv::Mat::refcount($mat) };
	err_is('mat is not of type const CvMat * in Cv::Mat::refcount');
	e { Cv::Mat::cvReleaseMat($mat) };
	err_is('mat is not of type CvMat * in Cv::Mat::cvReleaseMat');
}
