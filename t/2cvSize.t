# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my $isz = cvSize(1.1, 2.3);
is($isz->[0], 1);
is($isz->[1], 2);

my $nsz = cvSize2D32f(1.5, 2.5);
is($nsz->[0], 1.5);
is($nsz->[1], 2.5);

eval { Cv::cvCreateImage("x", 8, 3) };
like($@, '/ line ' . (__LINE__ - 1) . '\b/');

eval { Cv::cvCreateImage([], 8, 3) };
like($@, '/ line ' . (__LINE__ - 1) . '\b/');

eval { Cv::cvCreateImage([1, 'x'], 8, 3) };
like($@, '/ line ' . (__LINE__ - 1) . '\b/');

eval { Cv::cvCreateImage(['x', 2.1], 8, 3) };
like($@, '/ line ' . (__LINE__ - 1) . '\b/');
