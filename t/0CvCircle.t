# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN {	use_ok('Cv', -more) }

my $center = [ unpack("f*", pack("f*", map { rand 1 } 0..1)) ];
my $radius = unpack("f", pack("f", map { rand 1 } 0));

SKIP: {
	skip "no T", 7 unless Cv->can('CvCircle');

	{
		my $c = Cv::cvCircle($center, $radius);
		is_deeply($c, [$center, $radius]);
		my $c2 = Cv::CvCircle($c);
		is_deeply($c2, $c);
	}

	e { Cv::CvCircle([]) };
	err_is("Cv::CvCircle: circle is not of type CvCircle");

	e { Cv::CvCircle(['x', $radius]) };
	err_is("Cv::CvCircle: circle is not of type CvCircle");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvCircle([$center, '2x']) };
		err_is("Argument \"2x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $c = e { Cv::CvCircle([$center, '2x']) };
		err_is("");
		is_deeply($c, [$center, 2]);
	}
}
