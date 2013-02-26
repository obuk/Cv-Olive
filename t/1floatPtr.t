# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
use Test::Exception;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

my @floatPtr = unpack("f*", pack("f*", map { rand 1 } 1 .. 100));

if (1) {
	{
		my $floatPtr = Cv::floatPtr(\@floatPtr);
		is_deeply($floatPtr, \@floatPtr);
	}

	throws_ok { Cv::floatPtr({}) } qr/values is not of type float \* in Cv::floatPtr at $0/;

	{
		use warnings FATAL => qw(all);
		throws_ok { Cv::floatPtr(['1x']) } qr/Argument \"1x\" isn't numeric in subroutine entry at $0/;
	}

	{
		no warnings 'numeric';
		my $x; lives_ok { $x = Cv::floatPtr([1, '2x', 3]) };
		is_deeply($x, [1, 2, 3]);
	}
}
