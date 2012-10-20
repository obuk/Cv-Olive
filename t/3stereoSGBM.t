# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;
BEGIN {
	use_ok('Cv', qw(:nomore));
}

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
