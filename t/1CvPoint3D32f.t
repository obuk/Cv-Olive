# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More;
BEGIN {
	eval { use Cv -nomore };
	eval { require XSLoader; XSLoader::load('Cv::Test', $Cv::VERSION) };
	plan skip_all => "no Cv/Test.so" if $@;
	plan tests => 8;
}
use Test::Exception;
BEGIN { use_ok('Cv', -nomore) }

my ($x, $y, $z) = unpack("f*", pack("f*", map { rand 1 } 0..2));
my $pt = cvPoint3D32f($x, $y, $z);
is_deeply($pt, [ $x, $y, $z ]);

if (1) {
	{
		my $pt2 = Cv::CvPoint3D32f($pt);
		is_deeply($pt2, $pt);
	}

	throws_ok { Cv::CvPoint3D32f([]) } qr/pt is not of type CvPoint3D32f in Cv::CvPoint3D32f at $0/;

	throws_ok { Cv::CvPoint3D32f([1]) } qr/pt is not of type CvPoint3D32f in Cv::CvPoint3D32f at $0/;

	{
		use warnings FATAL => qw(all);
		throws_ok { Cv::CvPoint3D32f(['1x', '2y', '3z']) } qr/Argument \"1x\" isn't numeric in subroutine entry at $0/;
	}

	{
		no warnings 'numeric';
		my $x; lives_ok { $x = Cv::CvPoint3D32f(['1x', '2y', '3z']) };
		is_deeply($x, [1, 2, 3]);
	}
}
