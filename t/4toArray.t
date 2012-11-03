# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 21;

BEGIN {
	use_ok('Cv');
}


# CvtMatToArray()
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

	my @list2 = $arr->toArray([1, 1]);
	is(scalar @list2, 1);
	is($list2[0]->[0], 3);
	is($list2[0]->[1], 4);

	$arr->toArray(\my @list3);
	is(scalar @list3, 3);
	is($list3[0]->[0], 1);
	is($list3[0]->[1], 2);
	is($list3[1]->[0], 3);
	is($list3[1]->[1], 4);
	is($list3[2]->[0], 5);
	is($list3[2]->[1], 6);

	$arr->toArray(\my @list4, [0, 1]);
	is(scalar @list4, 2);
	is($list3[0]->[0], 1);
	is($list3[0]->[1], 2);
	is($list3[1]->[0], 3);
	is($list3[1]->[1], 4);
}


if (2) {
	my $arr = Cv::Mat->new([], CV_32FC2, [ [1, 2], [3, 4], [5, 6] ]);
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

	my @list2 = $arr->toArray([1, 2]);
	is(scalar @list2, 2);
	is($list2[0]->[0], 3);
	is($list2[0]->[1], 4);
	is($list2[1]->[0], 5);
	is($list2[1]->[1], 6);
}
