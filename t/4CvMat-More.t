# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 43;

BEGIN {
	use_ok('Cv');
}

if (1) {
	my $arr = eval { Cv::Mat->new([], CV_32FC1) };
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
						   [[1], [2], [3]],
						   [[1], [2], [3]],
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


if (1) {
	my $arr = Cv::Mat->new([ 3, 3 ], CV_16SC2);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 3);

	my @list = ();
	
	$arr->set(
		[],
		[ [ [ 0, 0 ], [ 0, 1 ], [ 0, 2 ], ],
		  [ [ 1, 0 ], [ 1, 1 ], [ 1, 2 ], ],
		  [ [ 2, 0 ], [ 2, 1 ], [ 2, 2 ], ], ],
		);

	is($arr->get([ 1, 0 ])->[0], 1); is($arr->get([ 1, 0 ])->[1], 0);
	is($arr->get([ 1, 1 ])->[0], 1); is($arr->get([ 1, 1 ])->[1], 1);
	is($arr->get([ 1, 2 ])->[0], 1); is($arr->get([ 1, 2 ])->[1], 2);

	$arr->set(
		[ 1 ],
		[ [ 11, 10 ], [ 11, 11 ], [ 11, 12 ], ],
		);

	is($arr->get([ 0, 0 ])->[0], 0); is($arr->get([ 0, 0 ])->[1], 0);
	is($arr->get([ 0, 1 ])->[0], 0); is($arr->get([ 0, 1 ])->[1], 1);
	is($arr->get([ 0, 2 ])->[0], 0); is($arr->get([ 0, 2 ])->[1], 2);

	is($arr->get([ 1, 0 ])->[0], 11); is($arr->get([ 1, 0 ])->[1], 10);
	is($arr->get([ 1, 1 ])->[0], 11); is($arr->get([ 1, 1 ])->[1], 11);
	is($arr->get([ 1, 2 ])->[0], 11); is($arr->get([ 1, 2 ])->[1], 12);

	is($arr->get([ 2, 0 ])->[0], 2); is($arr->get([ 2, 0 ])->[1], 0);
	is($arr->get([ 2, 1 ])->[0], 2); is($arr->get([ 2, 1 ])->[1], 1);
	is($arr->get([ 2, 2 ])->[0], 2); is($arr->get([ 2, 2 ])->[1], 2);

	$arr->set([ 1 ], [ 21, 0 ]);

	$arr->set([ 1, 0 ], [ 31, 0 ]);
	$arr->set([ 1, 1 ], [ 31, 1 ]);
	$arr->set([ 1, 2 ], [ 31, 2 ]);
}
