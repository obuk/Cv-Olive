# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -nomore) }

my ($width, $height) = unpack("f2", pack("f2", map { rand 1 } 0..1));
my $size = Cv::cvSize2D32f($width, $height);
is_deeply($size, [$width, $height]);

if (1) {
	{
		my $size2 = Cv::CvSize2D32f($size);
		is_deeply($size2, $size);
	}

	e { Cv::CvSize2D32f([]) };
	err_is("size is not of type CvSize2D32f in Cv::CvSize2D32f");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvSize2D32f(['1x', $height]) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
		e { Cv::CvSize2D32f([$width, '2x']) };
		err_is("Argument \"2x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $size2 = e { Cv::CvSize2D32f(['1x', '2x']) };
		err_is("");
		is_deeply($size2, [ 1, 2 ]);
	}
}
