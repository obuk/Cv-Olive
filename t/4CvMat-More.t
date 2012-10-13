# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 43;

BEGIN {
	use_ok('Cv');
	use_ok('Cv::More');
}

if (1) {
	my $arr = Cv::Mat->new([], CV_32FC1);
	ok(!$arr);
}

if (2) {
	my $arr = Cv::Mat->new([], CV_32FC1, [1]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 1);
	my $x = $arr->sum;
	is($x->[0], 1);
}

if (3) {
	my $arr = Cv::Mat->new([], CV_32FC1, [1, 2, 3]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);
	my $x = $arr->sum;
	is($x->[0], 1 + 2 + 3);
}

if (4) {
	my $arr = Cv::Mat->new([], CV_32FC1, [[1], [2], [3]]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);
	my $x = $arr->sum;
	is($x->[0], 1 + 2 + 3);
}

if (5) {
	my $arr = Cv::Mat->new([], CV_32FC3, [ [1, 2, 3] ]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 1);
	my $x = $arr->sum;
	is($x->[0], 1);
	is($x->[1], 2);
	is($x->[2], 3);
}

if (6) {
	my $arr = Cv::Mat->new([], CV_32FC1,
						   [1, 2, 3],
						   [1, 2, 3],
		);
	ok($arr);
	is($arr->rows, 2);
	is($arr->cols, 3);
	my $x = $arr->sum;
	is($x->[0], (1 + 2 + 3) * 2);
}

if (7) {
	my $arr = Cv::Mat->new([], CV_32FC3,
						   [ [1, 2, 3] ],
						   [ [1, 2, 3] ],
		);
	ok($arr);
	is($arr->rows, 2);
	is($arr->cols, 1);
	my $x = $arr->sum;
	is($x->[0], 1 * 2);
	is($x->[1], 2 * 2);
	is($x->[2], 3 * 2);
}

if (8) {
	my $arr = Cv::Mat->new([], CV_32FC3,
						   [
							[1, 2, 3],
							[1, 2, 3],
						   ],
		);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 2);
	my $x = $arr->sum;
	is($x->[0], 1 * 2);
	is($x->[1], 2 * 2);
	is($x->[2], 3 * 2);
}

if (9) {
	my $arr = Cv::Mat->new([], CV_32FC3,
						   [1, 2, 3],
						   [1, 2, 3],
		);
	ok($arr);
	is($arr->rows, 2);
	is($arr->cols, 1);
	my $x = $arr->sum;
	is($x->[0], 1 * 2);
	is($x->[1], 2 * 2);
	is($x->[2], 3 * 2);
}
