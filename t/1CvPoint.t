# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 10;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

my ($x, $y) = map { int rand 65536 } 0..1;
my $pt = cvPoint($x, $y);
is_deeply($pt, [ $x, $y ]);

if (1) {
	{
		my $pt2 = Cv::CvPoint($pt);
		is_deeply($pt2, $pt);
	}

	e { Cv::CvPoint([]) };
	err_is("pt is not of type CvPoint in Cv::CvPoint");

	e { Cv::CvPoint([1]) };
	err_is("pt is not of type CvPoint in Cv::CvPoint");

	{
		use warnings FATAL => qw(all);
		my $pt2 = e { Cv::CvPoint(['1x', '2y']) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $pt2 = e { Cv::CvPoint(['1x', '2y']) };
		err_is($@, "");
		is_deeply($pt2, [ 1, 2 ]);
	}

	eval "use Time::Piece";
	if ($@) {
		ok(1);
	} else {
		my $t1 = Time::Piece->strptime("2012-01-01", "%Y-%m-%d");
		my $t2 = Time::Piece->strptime("2012-01-02", "%Y-%m-%d");
		my $pt2 = Cv::CvPoint([$t2 - $t1, 0]);
		is_deeply($pt2, [ $t2 - $t1, 0 ]);
	}
}
