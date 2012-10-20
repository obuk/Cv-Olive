# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}


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
