# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
BEGIN { use_ok('Cv', -nomore) }

if (1) {
	my $a = Cv->createMat(2, 2, CV_64FC1)
		->setReal([0, 0], 5)->setReal([0, 1], 6)
		->setReal([1, 0], 7)->setReal([1, 1], 8);

	my $b = Cv->createMat(2, 2, CV_64FC1)
		->setReal((0, 0), 1)->setReal((0, 1), 2)
		->setReal((1, 0), 3)->setReal((1, 1), 4);

	my $c = Cv->createMat(2, 2, CV_64FC1);

	my $s = 2;
	$a->scaleAdd([$s], $b, $c);

	is($c->getReal([0, 0]), $s * $a->getReal(0, 0) + $b->getReal(0, 0));
	is($c->getReal([0, 1]), $s * $a->getReal(0, 1) + $b->getReal(0, 1));
	is($c->getReal([1, 0]), $s * $a->getReal(1, 0) + $b->getReal(1, 0));
	is($c->getReal([1, 1]), $s * $a->getReal(1, 1) + $b->getReal(1, 1));
}


SKIP: {
	skip "Test::Exception required", 3 unless eval "use Test::Exception";

	{
		my $a = Cv->createMat(2, 2, CV_64FC1);
		throws_ok { $a->scaleAdd(1, 2, 3) } qr/Usage: Cv::Arr::cvScaleAdd\(src1, scale, src2, dst\) at $0/;
	}

	{
		my $a = Cv->createMat(2, 2, CV_64FC1);
		throws_ok { $a->scaleAdd(1) } qr/scale is not of type CvScalar in Cv::Arr::cvScaleAdd at $0/;
	}

	{
		my $a = Cv->createMat(2, 2, CV_64FC1);
		my $b = Cv->createMat(2, 2, CV_64FC2);
		my $c = Cv->createMat(2, 2, CV_64FC3);
		throws_ok { $a->scaleAdd([2], $b, $c) } qr/OpenCV Error:/;
	}
}
