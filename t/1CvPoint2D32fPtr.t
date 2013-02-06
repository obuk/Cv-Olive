# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
use File::Basename;
use lib map { dirname($0) . "/$_" } qw(. ../.lib/arch ../.lib/lib); # XXXXX
use MY;
BEGIN {	use_ok('Cv', -more) }
BEGIN {	use_ok('Cv::T') }

my ($x, $y) = unpack("f*", pack("f*", map { rand 1 } 0..1));

if (1) {
	my $arr = Cv::cvPoint2D32fPtr($x, $y);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);
	is_deeply($arr, [ [ $x, $y ] ]);

	{
		my $arr2 = Cv::CvPoint2D32fPtr($arr->[0]);
		is_deeply($arr2, $arr);
	}

	e { Cv::CvPoint2D32fPtr([]) };
	err_is("pt is not of type CvPoint2D32f in Cv::CvPoint2D32fPtr");

	e { Cv::CvPoint2D32fPtr([1]) };
	err_is("pt is not of type CvPoint2D32f in Cv::CvPoint2D32fPtr");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvPoint2D32fPtr(['1x', '2y']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $arr2 = e { Cv::CvPoint2D32fPtr(['1x', '2y']) };
		err_is("");
		is_deeply($arr2, [ [1, 2] ]);
	}
}
