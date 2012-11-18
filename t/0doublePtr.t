# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 102;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my @doublePtr = map { int rand 1 } 1 .. 100;

SKIP: {
	skip "no T", 100 unless Cv->can('doublePtr');
	my $line;

	my $doublePtr = Cv::doublePtr(\@doublePtr);
	is($doublePtr->[$_], $doublePtr[$_]) for 0 .. $#doublePtr;

	$line = __LINE__ + 1;
	eval { Cv::doublePtr() };
	is($@, "Usage: Cv::doublePtr(values) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::doublePtr({}) };
	is($@, "Cv::doublePtr: values is not of type double * at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::doublePtr([ '1x' ]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::doublePtr([1, "2x", 3]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::doublePtr([1, 2, "3x"]) };
	is($@, "");

}
