# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 18;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

my @val = unpack("d*", pack("d*", map { rand 1 } 0..3));
my $scalar = Cv::cvScalar(@val);
is_deeply($scalar, \@val);

{
	my $sc = Cv::cvScalar($val[0]);
	is_deeply($sc, [ $val[0], 0, 0, 0 ]);
}

{
	my $sc = Cv::cvScalar(@val[0 .. 1]);
	is_deeply($sc, [ @val[0 .. 1], 0, 0 ]);
}

{
	my $sc = Cv::cvScalar(@val[0 .. 2]);
	is_deeply($sc, [ @val[0 .. 2], 0 ]);
}

TODO: {
	local $TODO = "usage";

	e { Cv::cvScalar() };
	err_is("Usage: Cv::cvScalar(val0, val1=0, val2=0, val3=0)");

	e { Cv::cvScalar(1, 2, 3, 4, 5) };
	err_is("Usage: Cv::cvScalar(val0, val1=0, val2=0, val3=0)");
}

if (1) {
	{
		my $sc = Cv::CvScalar($scalar);
		is_deeply($sc, $scalar);
	}

	{
		e { Cv::CvScalar() };
		err_is("Usage: Cv::CvScalar(scalar)");
	}

	{
		no warnings 'numeric';
		my $sc = e { Cv::CvScalar(['1x', $val[1], $val[2], $val[3]]) };
		err_is("");
		is_deeply($sc, [ 1, @val[1..3] ]);
	}

	{
		no warnings 'numeric';
		my $sc = e { Cv::CvScalar([$val[0], '2x', $val[2], $val[3]]) };
		err_is("");
		is_deeply($sc, [ $val[0], 2, @val[2..3] ]);
	}

	{
		no warnings 'numeric';
		my $sc = e { Cv::CvScalar([$val[0], $val[1], '3x', $val[3]]) };
		err_is("");
		is_deeply($sc, [ @val[0..1], 3, $val[3] ]);
	}

	{
		no warnings 'numeric';
		my $sc = e { Cv::CvScalar([$val[0], $val[1], $val[2], '4x']) };
		err_is("");
		is_deeply($sc, [ @val[0..2], 4 ]);
	}
}
