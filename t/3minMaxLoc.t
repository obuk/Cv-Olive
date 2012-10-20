# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

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
	is($minLoc->[$_], $minLocExpect->[$_]) for 0 .. 1;
	is($maxLoc->[$_], $maxLocExpect->[$_]) for 0 .. 1;
}

if (2) {
	$arr->MinMaxLoc(my $minVal, my $maxVal, my $minLoc, my $maxLoc);
	is($minVal, $minValExpect);
	is($maxVal, $maxValExpect);
	is($minLoc->[$_], $minLocExpect->[$_]) for 0 .. 1;
	is($maxLoc->[$_], $maxLocExpect->[$_]) for 0 .. 1;
}

if (3) {
	$arr->minMaxLoc(my $minVal, my $maxVal);
	is($minVal, $minValExpect);
	is($maxVal, $maxValExpect);
}

if (4) {
	eval { $arr->MinMaxLoc; };
	like($@, qr/Usage/);
}
