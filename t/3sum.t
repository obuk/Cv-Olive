# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

my $src = Cv::Mat->new([ 3, 3 ], CV_8UC4);
$src->fill([0, 1, 2, 3]);
my $dst = $src->sum;
is($dst->[0], 0 * 9);
is($dst->[1], 1 * 9);
is($dst->[2], 2 * 9);
is($dst->[3], 3 * 9);
