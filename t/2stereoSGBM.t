# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -more) }

SKIP: {
	skip "no Cv->CreateStereoSGBM", 5 unless Cv->can('CreateStereoSGBM');
	if (1) {
		my @av;
		no warnings;
		local *{Cv::StereoSGBM::new} = sub { @av = @_ };
		Cv->CreateStereoSGBM(1, 2, 3);
		is($av[0], 'Cv::StereoSGBM');
		is($av[1], 1);
		is($av[2], 2);
		is($av[3], 3);
	}
	if (10) {
		e { Cv->CreateStereoSGBM(0) };
		err_is('Usage: Cv::StereoSGBM::new(CLASS)');
	}
}

