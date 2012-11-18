# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 17;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my $center = [ map { (int rand 16384) + 0.5 } 0..1 ];
my $size = [ map { (int rand 16384) + 0.5 } 0..1 ];
my $angle = (int rand 16384) + 0.5;

SKIP: {
	skip "no T", 16 unless Cv->can('CvBox2D');
	my $line;

	my $box = Cv::cvBox2D($center, $size, $angle);
	is($box->[0]->[$_], $center->[$_]) for 0 .. 1;
	is($box->[1]->[$_], $size->[$_]) for 0 .. 1;
	is($box->[2], $angle);

	my $out = Cv::CvBox2D($box);
	is($out->[0]->[$_], $box->[0]->[$_]) for 0 .. 1;
	is($out->[1]->[$_], $box->[1]->[$_]) for 0 .. 1;
	is($out->[2],       $box->[2]);

	$line = __LINE__ + 1;
	eval { Cv::CvBox2D() };
	is($@, "Usage: Cv::CvBox2D(box) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvBox2D([]) };
	is($@, "Cv::CvBox2D: box is not of type CvBox2D at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvBox2D(['x', $size, $angle]) };
	is($@, "Cv::CvBox2D: box is not of type CvBox2D at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvBox2D([$center, 'x', $angle]) };
	is($@, "Cv::CvBox2D: box is not of type CvBox2D at $0 line $line.\n");

	$line = __LINE__ + 1;
	my $pt2 = eval { Cv::CvBox2D([$center, $size, '1.5x']) };
	is($@, "");
	is($pt2->[2], 1.5);

}
