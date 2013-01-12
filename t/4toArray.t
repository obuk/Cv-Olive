# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 61;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv') }

# CvtMatToArray()
if (1) {
	my $arr = Cv::Mat->new([], CV_32FC2, [1, 2], [3, 4], [5, 6]);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 1);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	splice(@$_, CV_MAT_CN($arr->type)) for @list; # XXXXX
	is_deeply($list[0], [1, 2]);
	is_deeply($list[1], [3, 4]);
	is_deeply($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 1]);
	is(scalar @list2, 1);
	splice(@$_, CV_MAT_CN($arr->type)) for @list2; # XXXXX
	is_deeply($list2[0], [3, 4]);

	$arr->toArray(\my @list3);
	is(scalar @list3, 3);
	splice(@$_, CV_MAT_CN($arr->type)) for @list3; # XXXXX
	is_deeply($list3[0], [1, 2]);
	is_deeply($list3[1], [3, 4]);
	is_deeply($list3[2], [5, 6]);

	$arr->toArray(\my @list4, [0, 1]);
	is(scalar @list4, 2);
	splice(@$_, CV_MAT_CN($arr->type)) for @list4; # XXXXX
	is_deeply($list4[0], [1, 2]);
	is_deeply($list4[1], [3, 4]);
}

if (2) {
	my $arr = Cv::Mat->new([], CV_32FC2, [ [1, 2], [3, 4], [5, 6] ]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);

	my @list = $arr->toArray;
	is(scalar @list, 3);
	splice(@$_, CV_MAT_CN($arr->type)) for @list; # XXXXX
	is_deeply($list[0], [1, 2]);
	is_deeply($list[1], [3, 4]);
	is_deeply($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 2]);
	is(scalar @list2, 2);
	splice(@$_, CV_MAT_CN($arr->type)) for @list2; # XXXXX
	is_deeply($list2[0], [3, 4]);
	is_deeply($list2[1], [5, 6]);
}

if (3) {
	my $arr = Cv::Mat->new(
		[], CV_32FC1,
		[ 11, 12, 13 ],
		[ 21, 22, 23 ],
		[ 31, 32, 33 ],
		);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 3);
	e { my @list = @$arr };
	err_is("can't convert 3x3 in Cv::Arr::ToArray");
}


# MatND
if (11) {
	my $arr = Cv::MatND->new([], CV_32FC2, [1, 2], [3, 4], [5, 6]);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 0);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	splice(@$_, CV_MAT_CN($arr->type)) for @list;	# XXXXX
	is_deeply($list[0], [1, 2]);
	is_deeply($list[1], [3, 4]);
	is_deeply($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 1]);
	is(scalar @list2, 1);
	splice(@$_, CV_MAT_CN($arr->type)) for @list2; # XXXXX
	is_deeply($list2[0], [3, 4]);

	$arr->toArray(\my @list3);
	is(scalar @list3, 3);
	splice(@$_, CV_MAT_CN($arr->type)) for @list3; # XXXXX
	is_deeply($list3[0], [1, 2]);
	is_deeply($list3[1], [3, 4]);
	is_deeply($list3[2], [5, 6]);

	$arr->toArray(\my @list4, [0, 1]);
	is(scalar @list4, 2);
	splice(@$_, CV_MAT_CN($arr->type)) for @list4; # XXXXX
	is_deeply($list4[0], [1, 2]);
	is_deeply($list4[1], [3, 4]);
}

if (12) {
	my $arr = Cv::MatND->new([], CV_32FC2, [ [1, 2], [3, 4], [5, 6] ]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);

	my @list = $arr->toArray;
	is(scalar @list, 3);
	splice(@$_, CV_MAT_CN($arr->type)) for @list; # XXXXX
	is_deeply($list[0], [1, 2]);
	is_deeply($list[1], [3, 4]);
	is_deeply($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 2]);
	is(scalar @list2, 2);
	splice(@$_, CV_MAT_CN($arr->type)) for @list2; # XXXXX
	is_deeply($list2[0], [3, 4]);
	is_deeply($list2[1], [5, 6]);
}

if (13) {
	my $arr = Cv::MatND->new(
		[], CV_32FC1,
		[ 11, 12, 13 ],
		[ 21, 22, 23 ],
		[ 31, 32, 33 ],
		);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 3);
	e { my @list = @$arr };
	err_is("can't convert 3x3 in Cv::Arr::ToArray");
}
