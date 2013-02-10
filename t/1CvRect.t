# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -more) }

my ($x, $y, $width, $height) = map { int rand 16384 } 0..3;
my $rect = Cv::cvRect($x, $y, $width, $height);
is_deeply($rect, [$x, $y, $width, $height]);

if (1) {
	{
		my $rect2 = Cv::CvRect($rect);
		is_deeply($rect2, $rect);
	}

	e { Cv::CvRect([]) };
	err_is("rect is not of type CvRect in Cv::CvRect");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvRect(['1x', $y, $width, $height]) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
		e { Cv::CvRect([$x, '2x', $width, $height]) };
		err_is("Argument \"2x\" isn't numeric in subroutine entry");
		e { Cv::CvRect([$x, $y, '3x', $height]) };
		err_is("Argument \"3x\" isn't numeric in subroutine entry");
		e { Cv::CvRect([$x, $y, $width, '4x']) };
		err_is("Argument \"4x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $rect2 = e { Cv::CvRect(['1x', '2x', '3x', '4x']) };
		err_is("");
		is_deeply($rect2, [ 1, 2, 3, 4 ]);
	}
}

