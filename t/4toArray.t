# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 21;

BEGIN {
	use_ok('Cv');
}


our $line;

sub err_is {
	our $line;
	chop(my $a = $@);
	my $b = shift(@_) . " at $0 line $line";
	$b .= '.' if $a =~ m/\.$/;
	unshift(@_, "$a\n", "$b\n");
	goto &is;
}

sub is_array {
	my $a = shift;
	my $b = shift;
	unshift(@_,
			sprintf("[%s]", join(', ', @{$a}[0..$#{$b}])),
			sprintf("[%s]", join(', ', @$b)),
		);
	goto &is;
}

# CvtMatToArray()
if (1) {
	my $arr = Cv::Mat->new([], CV_32FC2, [1, 2], [3, 4], [5, 6]);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 1);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	is_array($list[0], [1, 2]);
	is_array($list[1], [3, 4]);
	is_array($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 1]);
	is(scalar @list2, 1);
	is_array($list2[0], [3, 4]);

	$arr->toArray(\my @list3);
	is(scalar @list3, 3);
	is_array($list3[0], [1, 2]);
	is_array($list3[1], [3, 4]);
	is_array($list3[2], [5, 6]);

	$arr->toArray(\my @list4, [0, 1]);
	is(scalar @list4, 2);
	is_array($list4[0], [1, 2]);
	is_array($list4[1], [3, 4]);
}

if (2) {
	my $arr = Cv::Mat->new([], CV_32FC2, [ [1, 2], [3, 4], [5, 6] ]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);

	my @list = $arr->toArray;
	is(scalar @list, 3);
	is_array($list[0], [1, 2]);
	is_array($list[1], [3, 4]);
	is_array($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 2]);
	is(scalar @list2, 2);
	is_array($list2[0], [3, 4]);
	is_array($list2[1], [5, 6]);
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
	$line = __LINE__ + 1;
	eval { my @list = @$arr };
	err_is("Cv::Arr::ToArray: can't convert 3x3");
}


# MatND
if (11) {
	my $arr = Cv::MatND->new([], CV_32FC2, [1, 2], [3, 4], [5, 6]);
	ok($arr);
	is($arr->rows, 3);
	is($arr->cols, 0);
	my @list = $arr->toArray;
	is(scalar @list, 3);
	is_array($list[0], [1, 2]);
	is_array($list[1], [3, 4]);
	is_array($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 1]);
	is(scalar @list2, 1);
	is_array($list2[0], [3, 4]);

	$arr->toArray(\my @list3);
	is(scalar @list3, 3);
	is_array($list3[0], [1, 2]);
	is_array($list3[1], [3, 4]);
	is_array($list3[2], [5, 6]);

	$arr->toArray(\my @list4, [0, 1]);
	is(scalar @list4, 2);
	is_array($list4[0], [1, 2]);
	is_array($list4[1], [3, 4]);
}

if (12) {
	my $arr = Cv::MatND->new([], CV_32FC2, [ [1, 2], [3, 4], [5, 6] ]);
	ok($arr);
	is($arr->rows, 1);
	is($arr->cols, 3);

	my @list = $arr->toArray;
	is(scalar @list, 3);
	is_array($list[0], [1, 2]);
	is_array($list[1], [3, 4]);
	is_array($list[2], [5, 6]);

	my @list2 = $arr->toArray([1, 2]);
	is(scalar @list2, 2);
	is_array($list2[0], [3, 4]);
	is_array($list2[1], [5, 6]);
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
	$line = __LINE__ + 1;
	eval { my @list = @$arr };
	err_is("Cv::Arr::ToArray: can't convert 3x3");
}
