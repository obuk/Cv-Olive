# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 10;
BEGIN {
	use_ok('Cv', -more);
}

my @v = Cv::CV_VERSION;
is($v[0], Cv::CV_MAJOR_VERSION);
is($v[1], Cv::CV_MINOR_VERSION);
is($v[2], Cv::CV_SUBMINOR_VERSION);
my $v = Cv::CV_VERSION;
is($v, join('.', @v));
is(Cv::cvVersion(), $v[0] + $v[1] * 1e-3 + $v[2] * 1e-6);
diag "OpenCV $v";
is(scalar Cv::Version, Cv::cvVersion());
is(scalar Cv::version, cvVersion());
is(scalar Cv->Version, Cv::cvVersion());
is(scalar Cv->version, cvVersion());
