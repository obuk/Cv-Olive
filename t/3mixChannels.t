# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

if (1) {
	my $rgba = Cv::Mat->new([100, 100], CV_8UC4);
	my $bgr = $rgba->new(CV_8UC3);
	my $alpha = $rgba->new(CV_8UC1);
	$rgba->Fill(cvScalar([map { ord $_ } split(//, "rgba")]));
	my $fromTo = [ (0, 2), (1, 1), (2, 0), (3, 3) ];
	Cv->MixChannels([ $rgba ], [ $bgr, $alpha ], $fromTo);
	is($rgba->get(0, 0)->[0], $bgr->get(0, 0)->[2]);
	is($rgba->get(0, 0)->[1], $bgr->get(0, 0)->[1]);
	is($rgba->get(0, 0)->[2], $bgr->get(0, 0)->[0]);
	is($rgba->get(0, 0)->[3], $alpha->get(0, 0)->[0]);
}

if (10) {
	e { Cv->mixChannels; };
	err_is('Usage: Cv::cvMixChannels(src, dst, fromTo)');
}

if (11) {
	my $rgba = Cv::Mat->new([100, 100], CV_8UC4);
	my $bgr = $rgba->new(CV_8UC1);
	my $alpha = $rgba->new(CV_8UC1);
	my $fromTo = [ (0, 2), (1, 1), (2, 0), (3, 3) ];
	e { Cv->MixChannels([ $rgba ], [ $bgr, $alpha ], $fromTo) };
	err_like('OpenCV Error:');
}
