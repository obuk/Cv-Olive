# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 12;
BEGIN {	use_ok('Cv', -more) }

my $center = [ map { (int rand 16384) + 0.5 } 0..1 ];
my $radius = (int rand 16384) + 0.5;

SKIP: {
	skip "no T", 11 unless Cv->can('CvCircle');
	my $line;

	my $circle = Cv::cvCircle($center, $radius);
	is($circle->[0]->[$_], $center->[$_]) for 0 .. 1;
	is($circle->[1], $radius);

	my $out = Cv::CvCircle($circle);
	is($out->[0]->[$_], $circle->[0]->[$_]) for 0 .. 1;
	is($out->[1],       $circle->[1]);

	$line = __LINE__ + 1;
	eval { Cv::CvCircle() };
	is($@, "Usage: Cv::CvCircle(circle) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvCircle([]) };
	is($@, "Cv::CvCircle: circle is not of type CvCircle at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvCircle(['x', $radius]) };
	is($@, "Cv::CvCircle: circle is not of type CvCircle at $0 line $line.\n");

	$line = __LINE__ + 1;
	my $pt2 = eval { Cv::CvCircle([$center, '2x']) };
	is($@, "");
	is($pt2->[1], 2);

}
