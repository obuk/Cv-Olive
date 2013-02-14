# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

my ($x, $y) = map { (int rand 65536) } 0..1;

if (1) {
	my $arr = Cv::cvPointPtr($x, $y);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);
	is_deeply($arr, [ [ $x, $y ] ]);

	{
		my $arr2 = Cv::CvPointPtr($arr->[0]);
		is_deeply($arr2, $arr);
	}

	e { Cv::CvPointPtr([]) };
	err_is("pt is not of type CvPoint in Cv::CvPointPtr");

	e { Cv::CvPointPtr([1]) };
	err_is("pt is not of type CvPoint in Cv::CvPointPtr");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvPointPtr(['1x', '2y']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $arr2 = e { Cv::CvPointPtr(['1x', '2y']) };
		err_is("");
		is_deeply($arr2, [ [1, 2] ]);
	}
}
