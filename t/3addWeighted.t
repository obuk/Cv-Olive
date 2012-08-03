# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

use File::Basename;
my $verbose = Cv->hasGUI;

my $win = "addWeighted";
my ($minbar, $maxbar) = (0, 50);

my $src1 = Cv->loadImage(dirname($0) . "/baboon.jpg");
my $src2 = Cv->loadImage(dirname($0) . "/lena.jpg");

if ($verbose) {
	Cv->namedWindow($win, 0);
	Cv->createTrackbar("alpha", $win, $minbar, $maxbar, \&onChange);
}

sub onChange {
	my $alpha = $_[0] || 0;
	$alpha /= $maxbar;
	my ($beta, $gamma) = (1.0 - $alpha, 0);
	my $added = $src1->addWeighted($alpha, $src2, $beta, $gamma);
	if ($verbose) {
		$added->show($win);
	}
}

&onChange;
foreach (($minbar) x 30, $minbar .. $maxbar, ($maxbar) x 30) {
	if ($verbose) {
		Cv->setTrackbarPos("alpha", $win, $_);
		my $c = Cv->waitKey(33);
		last if ($c > 0 && ($c & 0xff) == 27);
	}
}
