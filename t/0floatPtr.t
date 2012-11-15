# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 102;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my @floatPtr = map { int rand 1 } 1 .. 100;

SKIP: {
	skip "no T", 100 unless Cv->can('floatPtr');
	my $line;

	my $floatPtr = Cv::floatPtr(\@floatPtr);
	is($floatPtr->[$_], $floatPtr[$_]) for 0 .. $#floatPtr;

	$line = __LINE__ + 1;
	eval { Cv::floatPtr() };
	is($@, "Usage: Cv::floatPtr(values) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::floatPtr({}) };
	is($@, "Cv::floatPtr: values is not of type float * at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::floatPtr(['x']) };
	is($@, "Cv::floatPtr: values is not of type float * at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::floatPtr([1, [2], 3]) };
	is($@, "Cv::floatPtr: values is not of type float * at $0 line $line.\n");

}
