# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 10;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -nomore) }

my $center = [ unpack("f*", pack("f*", map { rand 1 } 0..1)) ];
my $size = [ unpack("f*", pack("f*", map { rand 1 } 0..1)) ];
my $angle = unpack("f", pack("f", map { rand 1 } 0));

if (1) {
	{
		my $b = Cv::cvBox2D($center, $size, $angle);
		is_deeply($b, [$center, $size, $angle]);
		my $b2 = Cv::CvBox2D($b);
		is_deeply($b2, $b);
	}

	e { Cv::CvBox2D([]) };
	err_is("box is not of type CvBox2D in Cv::CvBox2D");

	e { Cv::CvBox2D(['x', $size, $angle]) };
	err_is("box is not of type CvBox2D in Cv::CvBox2D");

	e { Cv::CvBox2D([$center, 'x', $angle]) };
	err_is("box is not of type CvBox2D in Cv::CvBox2D");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvBox2D([$center, $size, '1.5x']) };
		err_is("Argument \"1.5x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $b = e { Cv::CvBox2D([$center, $size, '1.5x']) };
		err_is('');
		is_deeply($b, [$center, $size, 1.5]);
	}
}
