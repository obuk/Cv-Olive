# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 3;

BEGIN {
	use_ok('Cv', -more);
}

my $verbose = Cv->hasGUI;

if (1) {
	my $rng = Cv->RNG(-1);
	ok($rng);
	ok($rng->isa("Cv::RNG"));
}

if (2) {
	my $rng = Cv->RNG(-1);
	$rng->arr(
		my $image = Cv::Image->new([240, 320], CV_8UC3),
		CV_RAND_NORMAL,
		cvScalarAll(127),
		cvScalarAll(64)
		);
	if ($verbose) {
		$image->Show("rng");
		Cv->WaitKey(1000);
	}
}
