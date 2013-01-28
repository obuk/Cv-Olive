# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 5;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

if (1) {
	my ($x, $y) = (map { int rand 1000 } 1..2);
	my ($a00, $a01) = (map { int rand 1000 } 1..2);
	my ($a10, $a11) = (map { int rand 1000 } 1..2);

	my $A = Cv::Mat->new([2, 2], CV_32FC1);
	$A->set([0, 0], [$a00]); $A->set([0, 1], [$a01]);
	$A->set([1, 0], [$a10]); $A->set([1, 1], [$a11]);

	my $B = Cv::Mat->new([2], CV_32FC1);
	$B->set([0], [ $a00 * $x + $a01 * $y ]);
	$B->set([1], [ $a10 * $x + $a11 * $y ]);

	my $X = Cv::Mat->new([2], CV_32FC1);
	my $r = $A->Solve($B, $X);
	is($r, 1);
	is($X->getReal(0), $x);
	is($X->getReal(1), $y);
}

if (2) {
	my $A = Cv::Mat->new([2, 2], CV_32FC1)->zero;
	my $B = Cv::Mat->new([2], CV_32FC1)->zero;
	my $X = Cv::Mat->new([2], CV_32FC1);
	my $r = $A->Solve($B, $X);
	is($r, 0);
}
