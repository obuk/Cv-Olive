# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More tests => 5;
BEGIN { use_ok('Cv') }

SKIP: {
	skip "Cv->captureFromCAM - cvVersion", 4 unless cvVersion() >= 2.000001;
	my $cap = Cv->captureFromCAM(0);
	skip "Cv->captureFromCAM - camera", 4 unless $cap;
	ok my $frame = $cap->query;
	my $fourcc;
	for (qw(DIVX HFYU DRAC XVID X264 MP1V)) {
		my $v = eval { Cv->createVideoWriter("a.avi", $_, 30, $frame->size) };
		$fourcc = $_, last if $v && !$@;
	}
	skip "Cv->createVideoWriter - fourcc)", 3 unless $fourcc;
	my $v1 = Cv->createVideoWriter("a.avi", $fourcc, 30, $frame->size);
	isa_ok($v1, 'Cv::VideoWriter');
	my $v2 = Cv->createVideoWriter("a.avi", $fourcc, 30, $frame->size);
	isa_ok($v2, 'Cv::VideoWriter');
	my $v3 = Cv->createVideoWriter("a.avi", $fourcc, 30, $frame->size);
	isa_ok($v3, 'Cv::VideoWriter');
	unlink("a.avi");
}
