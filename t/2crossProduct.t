# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More;
BEGIN {
	eval "use Test::Number::Delta within => 1e-4";
	if ($@) {
		plan skip_all => "Test::Number::Delta";
	} else {
		plan tests => 5;
	}
}
BEGIN { use_ok('Cv', -nomore) }

# ------------------------------------------------------------
# void cvCrossProduct(const CvArr* src1, const CvArr* src2, CvArr* dst)
# ------------------------------------------------------------

{
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
	delta_ok(cvScalar($x, $y, $z),
			 cvScalar($ay * $bz - $az * $by,
					  $az * $bx - $ax * $bz,
					  $ax * $by - $ay * $bx),
		);
}

{
	my $A = Cv::Mat->new([1], CV_32FC3);
	my $B = $A->new;
	my ($ax, $ay, $az) = map { rand } 1 .. 3;
	my ($bx, $by, $bz) = map { rand } 1 .. 3;
	$A->set([0], [$ax, $ay, $az]);
	$B->set([0], [$bx, $by, $bz]);
	$A->crossProduct($B, my $X = $A->new);
	delta_ok($X->get([0]),
			 cvScalar($ay * $bz - $az * $by,
					  $az * $bx - $ax * $bz,
					  $ax * $by - $ay * $bx),
		);
}


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	{
		my $A = Cv::Mat->new([1], CV_32FC3);
		throws_ok { $A->crossProduct(0, 0, 0) } qr/Usage: Cv::Arr::cvCrossProduct\(src1, src2, dst\) at $0/;
	}

	{
		my $A = Cv::Mat->new([1], CV_32FC3);
		throws_ok { $A->crossProduct() } qr/src2 is not of type CvArr \* in Cv::Arr::cvCrossProduct at $0/;
	}
}
