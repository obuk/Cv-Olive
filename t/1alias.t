# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 66;

BEGIN {
	use_ok('Cv', qw(:nomore));
	# use_ok('Cv::Seq');			# xxxxx
}

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


if (98) {
	# A-G
	# ok(Cv->assoc('CreateBGCodeBookModel'));
	# ok(Cv::BGCodeBookModel->assoc('new'));

	# ok(Cv->assoc('CreateKalman'));
	# ok(Cv::Kalman->assoc('new'));

	# ok(Cv->assoc('CreateMemStorage'));
	# ok(Cv::MemStorage->assoc('new'));

	ok(Cv->assoc('CreateStereoBMState'));
	ok(Cv::StereoBMState->assoc('new'));

	ok(Cv->assoc('CreateStereoGCState'));
	ok(Cv::StereoGCState->assoc('new'));

	ok(Cv->assoc('CreateStructuringElementEx'));
	ok(Cv::ConvKernel->assoc('new'));

	ok(Cv->assoc('CreateVideoWriter'));
	ok(Cv::VideoWriter->assoc('new'));

	ok(Cv->assoc('OpenFileStorage'));
	ok(Cv::FileStorage->assoc('new'));

	ok(Cv->assoc('InitFont'));
	ok(Cv::Font->assoc('new'));

	ok(Cv->assoc('LoadHaarClassifierCascade'));
	ok(Cv::HaarClassifierCascade->assoc('new'));
}


if (99) {
	# A-G
	ok(Cv->assoc('CreateBGCodeBookModel'));
	ok(Cv::BGCodeBookModel->assoc('new'));
	ok(Cv::BGCodeBookModel->assoc('Update'));
	ok(Cv::BGCodeBookModel->assoc('Diff'));
	ok(Cv::BGCodeBookModel->assoc('ClearStale'));

	# H-N
	ok(Cv::Histogram->assoc('Calc'));
	ok(Cv::Histogram->assoc('Clear'));
	ok(Cv::Histogram->assoc('Compare'));
	ok(Cv::Histogram->assoc('Normalize'));
	ok(Cv::Histogram->assoc('SetBinRanges'));
	ok(Cv::Histogram->assoc('Thresh'));

	ok(Cv::Image->assoc('Clear'));
	ok(Cv::Image->assoc('Clone'));
	ok(Cv::Image->assoc('CloneImage'));
	ok(Cv::Image->assoc('GetCOI'));
	ok(Cv::Image->assoc('GetImageCOI'));
	ok(Cv::Image->assoc('GetImageROI'));
	ok(Cv::Image->assoc('GetROI'));
	ok(Cv::Image->assoc('ResetImageROI'));
	ok(Cv::Image->assoc('ResetROI'));
	ok(Cv::Image->assoc('SetCOI'));
	ok(Cv::Image->assoc('SetImageCOI'));
	ok(Cv::Image->assoc('SetImageROI'));
	ok(Cv::Image->assoc('SetROI'));

	ok(Cv->assoc('CreateKalman'));
	ok(Cv::Kalman->assoc('new'));
	ok(Cv::Kalman->assoc('MP'));
	ok(Cv::Kalman->assoc('DP'));
	ok(Cv::Kalman->assoc('CP'));
	ok(Cv::Kalman->assoc('state_pre'));
	ok(Cv::Kalman->assoc('state_post'));
	ok(Cv::Kalman->assoc('transition_matrix'));
	ok(Cv::Kalman->assoc('control_matrix'));
	ok(Cv::Kalman->assoc('measurement_matrix'));
	ok(Cv::Kalman->assoc('process_noise_cov'));
	ok(Cv::Kalman->assoc('measurement_noise_cov'));
	ok(Cv::Kalman->assoc('error_cov_pre'));
	ok(Cv::Kalman->assoc('gain'));
	ok(Cv::Kalman->assoc('error_cov_post'));
	ok(Cv::Kalman->assoc('KalmanCorrect'));
	ok(Cv::Kalman->assoc('KalmanPredict'));

	ok(Cv->assoc('CreateMemStorage'));
	ok(Cv::MemStorage->assoc('new'));
	ok(Cv::MemStorage->assoc('bottom'));
	ok(Cv::MemStorage->assoc('top'));
	ok(Cv::MemStorage->assoc('parent'));
	ok(Cv::MemStorage->assoc('block_size'));
	ok(Cv::MemStorage->assoc('free_space'));
	ok(Cv::MemStorage->assoc('ClearMemStorage'));
	ok(Cv::MemStorage->assoc('Clear'));
	ok(Cv::MemStorage->assoc('CreateChildMemStorage'));
	ok(Cv::MemStorage->assoc('MemStorageAlloc'));
	ok(Cv::MemStorage->assoc('AllocString'));
	ok(Cv::MemStorage->assoc('Clear'));
	ok(Cv::MemStorage->assoc('MemStorageAllocString'));

	ok(Cv->assoc('CreateMat'));
	ok(Cv::Mat->assoc('new'));
	ok(Cv::Mat->assoc('refcount'));
	ok(Cv::Mat->assoc('Clear'));
	ok(Cv::Mat->assoc('Clone'));
	ok(Cv::Mat->assoc('CloneMat'));

	ok(Cv->assoc('CreateMatND'));
	ok(Cv::MatND->assoc('new'));
	ok(Cv::MatND->assoc('refcount'));
	ok(Cv::MatND->assoc('Clear'));
	ok(Cv::MatND->assoc('Clone'));
	ok(Cv::MatND->assoc('CloneMat'));

	# O-U
	ok(Cv::RNG->assoc('Arr'));
	ok(Cv::RNG->assoc('Int'));
	ok(Cv::RNG->assoc('Real'));

	ok(Cv->assoc('CreateSeq'));
	ok(Cv::Seq->assoc('new'));
	ok(Cv::Seq->assoc('Clear'));
	ok(Cv::Seq->assoc('Clone'));

	ok(Cv->assoc('CreateSparseMat'));
	ok(Cv::SparseMat->assoc('new'));
	ok(Cv::SparseMat->assoc('refcount'));
	ok(Cv::SparseMat->assoc('Clear'));
	ok(Cv::SparseMat->assoc('Clone'));
	ok(Cv::SparseMat->assoc('CloneMat'));

	# V-Z
}
