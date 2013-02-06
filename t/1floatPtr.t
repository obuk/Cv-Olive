# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN {	use_ok('Cv', -more) }
BEGIN {	use_ok('Cv::T') }

my @floatPtr = unpack("f*", pack("f*", map { rand 1 } 1 .. 100));

if (1) {
	{
		my $floatPtr = Cv::floatPtr(\@floatPtr);
		is_deeply($floatPtr, \@floatPtr);
	}

	e { Cv::floatPtr({}) };
	err_is("values is not of type float * in Cv::floatPtr");

	{
		use warnings FATAL => qw(all);
		e { Cv::floatPtr(['1x']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $floatPtr2 = e { Cv::floatPtr([1, '2x', 3]) };
		err_is("");
		is_deeply($floatPtr2, [1, 2, 3]);
	}
}
