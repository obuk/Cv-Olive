# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

my @doublePtr = unpack("d*", pack("d*", map { rand 1 } 1 .. 100));

if (1) {
	{
		my $doublePtr = Cv::doublePtr(\@doublePtr);
		is_deeply($doublePtr, \@doublePtr);
	}

	e { Cv::doublePtr({}) };
	err_is("values is not of type double * in Cv::doublePtr");

	{
		use warnings FATAL => qw(all);
		e { Cv::doublePtr(['1x']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $doublePtr2 = e { Cv::doublePtr([1, '2x', 3]) };
		err_is("");
		is_deeply($doublePtr2, [1, 2, 3]);
	}
}
