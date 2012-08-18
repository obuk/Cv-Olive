# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 22;

BEGIN {
	use_ok('Cv');
}

# ------------------------------------------------------------
# CvMat* cvGetCols(const CvArr* arr, CvMat* submat, int startCol, int endCol)
# ------------------------------------------------------------

if (1) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (10, 10);
	my $submat = $src->GetCols;
	$src->set([$y0, $x0], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y0, $x0]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (2) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (10, 10);
	my $submat = Cv::Mat->new($src->sizes, $src->type, undef);
	$src->GetCols($submat);
	$src->set([$y0, $x0], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y0, $x0]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (3) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (10, 0);
	my $submat = $src->GetCols($x0, $x0 + 160);
	my ($x1, $y1) = (10, 20);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (4) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (20, 0);
	my $submat = $src->GetCols($x0, $x0 + 160);
	my ($x1, $y1) = (20, 30);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (5) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (30, 0);
	my $submat = $src->GetCols($x0);
	my ($x1, $y1) = (0, 0);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (6) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (30, 0);
	my $submat = $src->GetCols(
		$src->new([1, 80], $src->type, undef), $x0, $x0 + 80);
	my ($x1, $y1) = (0, 0);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

SKIP: {
	skip("need v2.0.0+", 3) unless cvVersion() >= 2.000000;
	Cv->setErrMode(1);
	my $can_hook = Cv->getErrMode() == 1;
	$can_hook = 0 if $^O eq 'cygwin';
	Cv->setErrMode(0);
	skip("can't hook cv:error", 3) unless $can_hook;

	if (11) {
		my $src = Cv::Mat->new([240, 320], CV_8UC3);
		my $submat = eval { $src->GetCols(10, 10) };
		ok($@);
	}

	if (12) {
		my $src = Cv::Mat->new([240, 320], CV_8UC3);
		my $submat = eval { $src->GetCols(10, 0) };
		ok($@);
	}

	if (13) {
		my $src = Cv::Mat->new([240, 320], CV_8UC3);
		no warnings 'redefine';
		local *Cv::Mat::new = sub { undef };
		my $submat = eval { $src->GetCols(100, 200) };
		like($@, qr/submat is not of type CvMat/);
	}
}