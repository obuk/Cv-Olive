# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 20;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -nomore) }

if (1) {
	my $mat = Cv::Mat->new([10, 10], CV_32FC1);
	ok($mat);
	is(ref $mat, 'Cv::Mat');
	is($mat->refcount, 1);
	Cv::Mat::cvReleaseMat($mat);
	is(ref $mat, 'SCALAR');
	e { Cv::Mat::refcount($mat) };
	err_is('mat is not of type CvMat * in Cv::Mat::refcount');
	e { Cv::Mat::DESTROY($mat) };
	err_is('mat is not of type CvMat * in Cv::Mat::cvReleaseMat');
}

if (2) {
	my $mat = Cv::MatND->new([10, 10], CV_32FC1);
	ok($mat);
	is(ref $mat, 'Cv::MatND');
	is($mat->refcount, 1);
	Cv::MatND::cvReleaseMatND($mat);
	is(ref $mat, 'SCALAR');
	e { Cv::MatND::refcount($mat) };
	err_is('mat is not of type CvMatND * in Cv::MatND::refcount');
	e { Cv::MatND::DESTROY($mat) };
	err_is('mat is not of type CvMatND * in Cv::MatND::cvReleaseMatND');
}

if (3) {
	my $mat = Cv::SparseMat->new([10, 10], CV_32FC1);
	ok($mat);
	is(ref $mat, 'Cv::SparseMat');
  TODO: {
	  local $TODO = "fix refcount (value of refcount is -1)";
	  is($mat->refcount, 1);
	}
	Cv::SparseMat::cvReleaseSparseMat($mat);
	is(ref $mat, 'SCALAR');
	e { Cv::SparseMat::refcount($mat) };
	err_is('mat is not of type CvSparseMat * in Cv::SparseMat::refcount');
	e { Cv::SparseMat::DESTROY($mat) };
	err_is('mat is not of type CvSparseMat * in Cv::SparseMat::cvReleaseSparseMat');
}
