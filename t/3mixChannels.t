# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

sub flatarray {
	my @arr = ();
	push(@arr, ref $_ eq 'ARRAY'? flatarray(@$_) : $_) for @_;
	@arr;
}

if (1) {
	my $rgba = Cv->CreateMat(100, 100, CV_8UC4);
	my $bgr = Cv->CreateMat($rgba->rows, $rgba->cols, CV_8UC3);
	my $alpha = Cv->CreateMat($rgba->rows, $rgba->cols, CV_8UC1);
	$rgba->Fill(cvScalar(50, 100, 150, 200));
	my @fromTo = flatarray([ 0, 2 ], [ 1, 1 ], [ 2, 0 ], [ 3, 3 ]);
	Cv->MixChannels([ $rgba ], [ $bgr, $alpha ], \@fromTo);
	is($rgba->get(0, 0)->[0], $bgr->get(0, 0)->[2]);
	is($rgba->get(0, 0)->[1], $bgr->get(0, 0)->[1]);
	is($rgba->get(0, 0)->[2], $bgr->get(0, 0)->[0]);
	is($rgba->get(0, 0)->[3], $alpha->get(0, 0)->[0]);
}
