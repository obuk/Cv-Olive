# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 227;

BEGIN {
	use_ok('Cv');
}

if (1) {
	my $arr = Cv::Mat->new([], CV_32FC2, [1, 2], [3, 4], [5, 6]);
	ok($arr);
	# print STDERR "(", join(", ", $arr->rows, $arr->cols), ")\n";
	is($arr->rows, 3);
	is($arr->cols, 1);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	is($list[0]->[0], 1);
	is($list[0]->[1], 2);
}

if (2) {
	my $arr = Cv::Mat->new([], CV_32FC2, [[1, 2], [3, 4], [5, 6]]);
	ok($arr);
	# print STDERR "(", join(", ", $arr->rows, $arr->cols), ")\n";
	is($arr->rows, 1);
	is($arr->cols, 3);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	is($list[0]->[0], 1);
	is($list[0]->[1], 2);
}
