# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

my $verbose = Cv->hasGUI;

if (1) {
	my $rng = Cv->RNG(-1);
	ok($rng);
	ok($rng->isa("Cv::RNG"));
}

if (0) {
	my $rng = Cv::RNG->new(-1);
	ok($rng);
	ok($rng->isa("Cv::RNG"));
}

if (3) {
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
