# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN {	use_ok('Cv', -more) }

my ($x, $y, $z) = unpack("f*", pack("f*", map { rand 1 } 0..2));
my $pt = cvPoint3D32f($x, $y, $z);
is_deeply($pt, [ $x, $y, $z ]);

SKIP: {
	skip "no T", 6 unless Cv->can('CvPoint3D32f');

	{
		my $pt2 = Cv::CvPoint3D32f($pt);
		is_deeply($pt2, $pt);
	}

	e { Cv::CvPoint3D32f([]) };
	err_is("Cv::CvPoint3D32f: pt is not of type CvPoint3D32f");

	e { Cv::CvPoint3D32f([1]) };
	err_is("Cv::CvPoint3D32f: pt is not of type CvPoint3D32f");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvPoint3D32f(['1x', '2y', '3z']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $pt2 = e { Cv::CvPoint3D32f(['1x', '2y', '3z']) };
		err_is("");
		is_deeply($pt2, [1, 2, 3]);
	}
}
