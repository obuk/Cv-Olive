# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
use File::Basename;
use lib map { dirname($0) . "/$_" } qw(. ../.lib/arch ../.lib/lib); # XXXXX
use MY;
BEGIN {	use_ok('Cv', -more) }
BEGIN {	use_ok('Cv::T') }

my ($width, $height) = map { int rand 16384 } 0..1;
my $size = Cv::cvSize($width, $height);
is_deeply($size, [$width, $height]);

if (1) {
	{
		my $size2 = Cv::CvSize($size);
		is_deeply($size2, $size);
	}

	e { Cv::CvSize([]) };
	err_is("size is not of type CvSize in Cv::CvSize");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvSize(['1x', $height]) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
		e { Cv::CvSize([$width, '2x']) };
		err_is("Argument \"2x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $size2 = e { Cv::CvSize(['1x', '2x']) };
		err_is("");
		is_deeply($size2, [ 1, 2 ]);
	}
}
