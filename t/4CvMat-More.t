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


if (10) {
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


if (11) {
	my $arr = Cv::Mat->new([ 3, 3 ], CV_16SC2);
	eval { $arr->set([ 3, 3 ], [ 1, 2 ]) };
	like($@, qr/values is out of range/);
}


# has data
if (12) {
	my $rows = 8;
	my $cols = 8;
	my $cn = 4;
	my $step = $cols * $cn;
	my $data = chr(0) x ($rows * $step);
	substr($data, 0 + $_, 1) = chr(0x41 + $_) for 0 .. $cn - 1;
	my $mat = Cv::Mat->new([ $rows, $cols ], CV_8UC($cn), $data);
	is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
}

if (13) {
	my $rows = 8;
	my $cols = 8;
	my $cn = 4;
	my $step = $cols * $cn;
	my $data = chr(0) x ($rows * $step);
	substr($data, 0 + $_, 1) = chr(0x41 + $_) for 0 .. $cn - 1;
	my $mat = Cv::Mat->new([ $rows, $cols ], CV_8UC($cn), $data, $step);
	is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
}

# cover
if (14) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (30, 0);
	my $submat = $src->GetCols(
		$src->new([1, 80], $src->type, undef), $x0, $x0 + 80);
	my ($x1, $y1) = (0, 0);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (15) {
	my $arr = Cv::Mat->new([240], CV_8UC3);
	ok($arr);
}

if (16) {
	my $arr = Cv::Mat->new([240], CV_8UC3)->new;
	is($arr->type, CV_8UC3);
}

if (17) {
	my $arr = Cv::Mat->new([], CV_8UC1, []);
}

if (18) {
	my $line = __LINE__ + 1;
	eval { Cv::Mat->new([], CV_32FC1, [1, 1], [2, 2, 2], [3, 3]) };
	is($@, "OpenCV Error: One of arguments' values is out of range (index is out of range) at $0 line $line\n");
}

