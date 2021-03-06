# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
BEGIN { use_ok('Cv', -nomore) }

SKIP: {
	skip "MixChannels 2.0.0", 4 if Cv->version == 2.00000;

# OpenCV Error: Assertion failed (src_count == dst_count && src_count == pair_count) in cvMixChannels at t/2mixChannels.t line 15

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


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	throws_ok { Cv->mixChannels; } qr/Usage: Cv::cvMixChannels\(src, dst, fromTo\) at $0/;

	my $rgba = Cv::Mat->new([100, 100], CV_8UC4);
	my $bgr = $rgba->new(CV_8UC1);
	my $alpha = $rgba->new(CV_8UC1);
	my $fromTo = [ (0, 2), (1, 1), (2, 0), (3, 3) ];
	throws_ok { Cv->MixChannels([ $rgba ], [ $bgr, $alpha ], $fromTo) } qr/OpenCV Error:/;
}
