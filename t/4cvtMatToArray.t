# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 22;

BEGIN {
	use_ok('Cv');
	use_ok('Cv::More');
}

if (1) {
	my $arr = Cv::Mat->new([], CV_32FC2, [1, 2], [3, 4], [5, 6]);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 1);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	is($list[0]->[0], 1);
	is($list[0]->[1], 2);
	is($list[1]->[0], 3);
	is($list[1]->[1], 4);
	is($list[2]->[0], 5);
	is($list[2]->[1], 6);
}

if (2) {
	my $arr = Cv::Mat->new([], CV_32FC2, [[1, 2], [3, 4], [5, 6]]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	is($list[0]->[0], 1);
	is($list[0]->[1], 2);
	is($list[1]->[0], 3);
	is($list[1]->[1], 4);
	is($list[2]->[0], 5);
	is($list[2]->[1], 6);
}
