# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 10;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN {	use_ok('Cv', -more) }

my ($x, $y, $z) = unpack("f*", pack("f*", map { rand 1 } 0..2));

SKIP: {
	skip "no T", 9 unless Cv->can('CvPoint3D32fPtr');

	my $arr = Cv::cvPoint3D32fPtr($x, $y, $z);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);
	is_deeply($arr, [ [ $x, $y, $z ] ]);

	{
		my $arr2 = Cv::CvPoint3D32fPtr($arr->[0]);
		is_deeply($arr2, $arr);
	}

	e { Cv::CvPoint3D32fPtr([]) };
	err_is("Cv::CvPoint3D32fPtr: pt is not of type CvPoint3D32f");

	e { Cv::CvPoint3D32fPtr([1]) };
	err_is("Cv::CvPoint3D32fPtr: pt is not of type CvPoint3D32f");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvPoint3D32fPtr(['1x', '2y', '3z']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $arr2 = e { Cv::CvPoint3D32fPtr(['1x', '2y', '3z']) };
		err_is("");
		is_deeply($arr2, [ [1, 2, 3] ]);
	}
}
