# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 6;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
# void cvCrossProduct(const CvArr* src1, const CvArr* src2, CvArr* dst)
# ------------------------------------------------------------

if (1) {
	my $A = Cv::Mat->new([3], CV_32FC1);
	my $B = $A->new;
	my ($ax, $ay, $az) = map { rand } 1 .. 3;
	my ($bx, $by, $bz) = map { rand } 1 .. 3;
	$A->set([0], [$ax]);
	$A->set([1], [$ay]);
	$A->set([2], [$az]);
	$B->set([0], [$bx]);
	$B->set([1], [$by]);
	$B->set([2], [$bz]);
	my $X = $A->crossProduct($B);
	my ($x, $y, $z) = ($X->getReal(0), $X->getReal(1), $X->getReal(2));
	is_({ round => "%.3g" }, cvScalar($x, $y, $z),
		cvScalar($ay * $bz - $az * $by,
				 $az * $bx - $ax * $bz,
				 $ax * $by - $ay * $bx),
		);
}

if (2) {
	my $A = Cv::Mat->new([1], CV_32FC3);
	my $B = $A->new;
	my ($ax, $ay, $az) = map { rand } 1 .. 3;
	my ($bx, $by, $bz) = map { rand } 1 .. 3;
	$A->set([0], [$ax, $ay, $az]);
	$B->set([0], [$bx, $by, $bz]);
	$A->crossProduct($B, my $X = $A->new);
	is_({ round => "%.4g" }, $X->get([0]),
		cvScalar($ay * $bz - $az * $by,
				 $az * $bx - $ax * $bz,
				 $ax * $by - $ay * $bx),
		);
}

if (10) {
	my $A = Cv::Mat->new([1], CV_32FC3);
	e { $A->crossProduct(0, 0, 0) };
	err_is("Usage: Cv::Arr::cvCrossProduct(src1, src2, dst)");
}

if (11) {
	my $A = Cv::Mat->new([1], CV_32FC3);
	e { $A->crossProduct() };
	err_is("src2 is not of type CvArr * in Cv::Arr::cvCrossProduct");
}
