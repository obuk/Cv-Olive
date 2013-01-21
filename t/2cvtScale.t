# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 5;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

if (1) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC1);
	my $arr2 = $arr->cvtScale(1, 0);
	is($arr2->type, $arr->type);
}

if (2) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC3);
	my $arr2 = $arr->cvtScale($arr->new(CV_32FC3), 1, 0);
	is($arr2->type, CV_32FC3);
}

if (10) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC3);
	e { $arr->cvtScale(1, 0, 1) };
	err_is('Usage: Cv::Arr::cvConvertScale(src, dst, scale=1, shift=0)');
}

if (11) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC3);
	e { $arr->cvtScale($arr->new([120, 160])) };
	err_like('OpenCV Error:');
}
