# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -nomore) }

my ($x, $y) = unpack("f*", pack("f*", map { rand 1 } 0..1));

if (1) {
	my $arr = Cv::cvPoint2D64fPtr($x, $y);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);
	is_deeply($arr, [ [ $x, $y ] ]);

	{
		my $arr2 = Cv::CvPoint2D64fPtr($arr->[0]);
		is_deeply($arr2, $arr);
	}

	e { Cv::CvPoint2D64fPtr([]) };
	err_is("pt is not of type CvPoint2D64f in Cv::CvPoint2D64fPtr");

	e { Cv::CvPoint2D64fPtr([1]) };
	err_is("pt is not of type CvPoint2D64f in Cv::CvPoint2D64fPtr");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvPoint2D64fPtr(['1x', '2y']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $arr2 = e { Cv::CvPoint2D64fPtr(['1x', '2y']) };
		err_is("");
		is_deeply($arr2, [ [1, 2] ]);
	}
}
