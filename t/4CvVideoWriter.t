# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 4;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv') }

SKIP: {
	my $cap = Cv->captureFromCAM(0);
	skip "can't capture #0", 3 unless $cap;
	my $frame = $cap->query;
	skip "can't query #0", 3 unless $frame;
	my $fourcc1 =  "DIVX";
	my $v1 = Cv->createVideoWriter("a.avi", $fourcc1, 30, $frame->size);
	isa_ok($v1, 'Cv::VideoWriter');
	my $fourcc2 =  CV_FOURCC("DIVX");
	my $v2 = Cv->createVideoWriter("a.avi", $fourcc2, 30, $frame->size);
	isa_ok($v2, 'Cv::VideoWriter');
	my $fourcc3 =  CV_FOURCC("DIVX");
	my $v3 = Cv->createVideoWriter("a.avi", $fourcc3, 30, $frame->size);
	isa_ok($v3, 'Cv::VideoWriter');
	unlink("a.avi");
}
