# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 66;
use Cv;

{
	package Cv::Something;
	sub cvSubroutineA { unshift(@_, 'a'); @_ }
	Cv::alias qw(SubroutineA SubrA SubA);
	sub SubroutineB { unshift(@_, 'b'); @_ }
	Cv->alias(qw(SubroutineB SubrB SubB));
}

if (1) {
	my @x = Cv::Something->subrA('x');
	is($x[0], 'a');
	is($x[1], 'Cv::Something');
	is($x[2], 'x');
}

if (2) {
	my @x = Cv::Something->subB('y');
	is($x[0], 'b');
	is($x[1], 'Cv::Something');
	is($x[2], 'y');
}

if (3) {
	{ package Cv; Cv::alias(qw(Foo)) }
	eval { Cv->Foo() };
	like($@, qr/TBD/);
	eval { Cv->foo() };
	like($@, qr/TBD/);
}

if (4) {
	{ package Cv; Cv::alias(qw(Bar), sub { die "xxx" }) }
	eval { Cv->Bar() };
	like($@, qr/^xxx at/);
	eval { Cv->bar() };
	like($@, qr/^xxx at/);
}

if (5) {
	is(&Cv::alias(), undef);
}


if (99) {
	# A-G
	ok(Cv::assoc('Cv', 'CreateBGCodeBookModel'));
	ok(Cv::assoc('Cv::BGCodeBookModel', 'new'));

	ok(Cv::assoc('Cv', 'CreateStructuringElementEx'));
	ok(Cv::assoc('Cv::ConvKernel', 'new'));

	ok(Cv::assoc('Cv', 'OpenFileStorage'));
	ok(Cv::assoc('Cv::FileStorage', 'new'));

	ok(Cv::assoc('Cv', 'InitFont'));
	ok(Cv::assoc('Cv::Font', 'new'));

	# H-N
	ok(Cv::assoc('Cv', 'LoadHaarClassifierCascade'));
	ok(Cv::assoc('Cv::HaarClassifierCascade', 'new'));

	ok(Cv::assoc('Cv::Histogram', 'Calc'));
	ok(Cv::assoc('Cv::Histogram', 'Clear'));
	ok(Cv::assoc('Cv::Histogram', 'Compare'));
	ok(Cv::assoc('Cv::Histogram', 'Normalize'));
	ok(Cv::assoc('Cv::Histogram', 'SetBinRanges'));
	ok(Cv::assoc('Cv::Histogram', 'Thresh'));

	ok(Cv::assoc('Cv::Image', 'GetROI'));
	ok(Cv::assoc('Cv::Image', 'GetImageROI'));
	ok(Cv::assoc('Cv::Image', 'SetROI'));
	ok(Cv::assoc('Cv::Image', 'SetImageROI'));
	ok(Cv::assoc('Cv::Image', 'ResetROI'));
	ok(Cv::assoc('Cv::Image', 'ResetImageROI'));
	ok(Cv::assoc('Cv::Image', 'GetCOI'));
	ok(Cv::assoc('Cv::Image', 'GetImageCOI'));
	ok(Cv::assoc('Cv::Image', 'SetCOI'));
	ok(Cv::assoc('Cv::Image', 'SetImageCOI'));
	ok(Cv::assoc('Cv::Image', 'Clone'));
	ok(Cv::assoc('Cv::Image', 'CloneImage'));
	ok(Cv::assoc('Cv::Image', 'Clear'));

	ok(Cv::assoc('Cv', 'CreateKalman'));
	ok(Cv::assoc('Cv::Kalman', 'new'));

	ok(Cv::assoc('Cv::Mat', 'Clone'));
	ok(Cv::assoc('Cv::Mat', 'CloneMat'));
	ok(Cv::assoc('Cv::Mat', 'Clear'));

	ok(Cv::assoc('Cv::MatND', 'Clone'));
	ok(Cv::assoc('Cv::MatND', 'CloneMat'));
	ok(Cv::assoc('Cv::MatND', 'Clear'));

	ok(Cv::assoc('Cv::MemStorage', 'MemStorageAllocString'));
	ok(Cv::assoc('Cv::MemStorage', 'AllocString'));
	ok(Cv::assoc('Cv::MemStorage', 'Clear'));
	ok(Cv::assoc('Cv::MemStorage', 'new'));

	# O-U
	ok(Cv::assoc('Cv::RNG', 'Arr'));
	ok(Cv::assoc('Cv::RNG', 'Int'));
	ok(Cv::assoc('Cv::RNG', 'Real'));

	ok(Cv::assoc('Cv::Seq', 'Clear'));
	ok(Cv::assoc('Cv::Seq', 'Clone'));

	ok(Cv::assoc('Cv::SparseMat', 'Clone'));
	ok(Cv::assoc('Cv::SparseMat', 'CloneMat'));
	ok(Cv::assoc('Cv::SparseMat', 'Clear'));

	ok(Cv::assoc('Cv', 'CreateStereoBMState'));
	ok(Cv::assoc('Cv::StereoBMState', 'new'));

	ok(Cv::assoc('Cv', 'CreateStereoGCState'));
	ok(Cv::assoc('Cv::StereoGCState', 'new'));

	# V-Z
	ok(Cv::assoc('Cv', 'CreateVideoWriter'));
	ok(Cv::assoc('Cv::VideoWriter', 'new'));
}
