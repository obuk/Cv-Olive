# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN {	use_ok('Cv', -more) }
BEGIN {	use_ok('Cv::T') }

my ($x, $y, $z) = unpack("d*", pack("d*", map { rand 1 } 0..2));
my $pt = cvPoint3D64f($x, $y, $z);
is_deeply($pt, [ $x, $y, $z ]);

if (1) {
	# typemap T_CvPoint
	{
		# OUTPUT
		my $pt2 = Cv::CvPoint3D64f($pt);
		is_deeply($pt2, $pt);
	}

	e { Cv::CvPoint3D64f([]) };
	err_is("pt is not of type CvPoint3D64f in Cv::CvPoint3D64f");

	e { Cv::CvPoint3D64f([1]) };
	err_is("pt is not of type CvPoint3D64f in Cv::CvPoint3D64f");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvPoint3D64f(['1x', '2y', '3z']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $pt2 = e { Cv::CvPoint3D64f(['1x', '2y', '3z']) };
		err_is("");
		is_deeply($pt2, [1, 2, 3]);
	}
}
