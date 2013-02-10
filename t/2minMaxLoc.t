# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 13;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -more) }

my $arr = Cv::Mat->new([240, 320], CV_64FC1);

my ($minValExpect, $minLocExpect,
	$maxValExpect, $maxLocExpect) = (
	-1, [ map { int rand $_ } ($arr->cols, $arr->rows) ],
	+1, [ map { int rand $_ } ($arr->cols, $arr->rows) ],
	);

$arr->zero
	->set([reverse @$minLocExpect], [$minValExpect])
	->set([reverse @$maxLocExpect], [$maxValExpect]);

if (1) {
	Cv::Arr::MinMaxLoc($arr, my $minVal, my $maxVal, my $minLoc, my $maxLoc, \0);
	is($minVal, $minValExpect);
	is($maxVal, $maxValExpect);
	is_deeply($minLoc, $minLocExpect);
	is_deeply($maxLoc, $maxLocExpect);
}

if (2) {
	$arr->MinMaxLoc(my $minVal, my $maxVal, my $minLoc, my $maxLoc);
	is($minVal, $minValExpect);
	is($maxVal, $maxValExpect);
	is_deeply($minLoc, $minLocExpect);
	is_deeply($maxLoc, $maxLocExpect);
}

if (3) {
	$arr->minMaxLoc(my $minVal, my $maxVal);
	is($minVal, $minValExpect);
	is($maxVal, $maxValExpect);
}

if (10) {
	e { $arr->MinMaxLoc; };
	err_is('Usage: Cv::Arr::cvMinMaxLoc(arr, min_val, max_val, min_loc, max_loc, mask=NULL)');
}
