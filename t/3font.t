# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 3;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

my $verbose = Cv->hasGUI;

if (1) {
	my $font = Cv->InitFont(CV_FONT_HERSHEY_SIMPLEX, 1.0, 1.0, 0, 2, CV_AA);
	isa_ok($font, 'Cv::Font');
	my $img = Cv->CreateImage([320, 240], 8, 3);
	$img->zero;
	$img->putText("Hello, World", [ 30, 30 ], $font, cvScalarAll(255));
	if ($verbose) {
		$img->show("Font");
		Cv->waitKey(1000);
	}
}

if (2) {
	ok(!Cv->hasQt);
}
