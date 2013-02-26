# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
use Test::Exception;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

my ($x, $y) = unpack("d*", pack("d*", map { rand 1 } 0..1));
my $pt = cvPoint2D64f($x, $y);
is_deeply($pt, [ $x, $y ]);

if (1) {
	{
		my $pt2 = Cv::CvPoint2D64f($pt);
		is_deeply($pt2, $pt);
	}

	throws_ok { Cv::CvPoint2D64f([]) } qr/pt is not of type CvPoint2D64f in Cv::CvPoint2D64f at $0/;

	throws_ok { Cv::CvPoint2D64f([1]) } qr/pt is not of type CvPoint2D64f in Cv::CvPoint2D64f at $0/;

	{
		use warnings FATAL => qw(all);
		throws_ok { Cv::CvPoint2D64f(['1x', '2y']) } qr/Argument \"1x\" isn't numeric in subroutine entry at $0/;
	}

	{
		no warnings 'numeric';
		my $x; lives_ok { $x = Cv::CvPoint2D64f(['1x', '2y']) };
		is_deeply($x, [1, 2]);
	}
}
