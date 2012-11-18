# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 102;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my @intPtr = map { int rand 65536 } 1 .. 100;

SKIP: {
	skip "no T", 100 unless Cv->can('intPtr');
	my $line;

	my $intPtr = Cv::intPtr(\@intPtr);
	is($intPtr->[$_], $intPtr[$_]) for 0 .. $#intPtr;

	$line = __LINE__ + 1;
	eval { Cv::intPtr() };
	is($@, "Usage: Cv::intPtr(values) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::intPtr({}) };
	is($@, "Cv::intPtr: values is not of type int * at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::intPtr(['1x']) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::intPtr([1, '2x', 3]) };
	is($@, "");

}
