# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
use Test::Exception;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

my ($x, $y, $z) = unpack("f*", pack("f*", map { rand 1 } 0..2));

if (1) {
	my $arr = Cv::cvPoint3D32fPtr($x, $y, $z);
	is(ref $arr, 'ARRAY');
	is(scalar @$arr, 1);
	is_deeply($arr, [ [ $x, $y, $z ] ]);

	{
		my $arr2 = Cv::CvPoint3D32fPtr($arr->[0]);
		is_deeply($arr2, $arr);
	}

	throws_ok { Cv::CvPoint3D32fPtr([]) } qr/pt is not of type CvPoint3D32f in Cv::CvPoint3D32fPtr at $0/;

	throws_ok { Cv::CvPoint3D32fPtr([1]) } qr/pt is not of type CvPoint3D32f in Cv::CvPoint3D32fPtr at $0/;

	{
		use warnings FATAL => qw(all);
		throws_ok { Cv::CvPoint3D32fPtr(['1x', '2y', '3z']) } qr/Argument \"1x\" isn't numeric in subroutine entry at $0/;
	}

	{
		no warnings 'numeric';
		my $x; lives_ok { $x = Cv::CvPoint3D32fPtr(['1x', '2y', '3z']) };
		is_deeply($x, [ [1, 2, 3] ]);
	}
}
