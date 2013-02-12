# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 3;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv') }

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

SKIP: {
	skip "no Qt", 1 unless Cv->hasQt;
	my $font = Cv->fontQt("Alias", 20);
	isa_ok($font, 'Cv::Font');
	my $img = Cv->CreateImage([320, 240], 8, 3);
	$img->fill(cvScalarAll(255));
	$img->addText("Hello, Qt", [ 50, 50 ], $font);
	if ($verbose) {
		$img->show("Font");
		Cv->waitKey(1000);
	}
}
