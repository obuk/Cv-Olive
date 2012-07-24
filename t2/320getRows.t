# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 27;

BEGIN {
	use_ok('Cv');
}

# ------------------------------------------------------------
# CvMat* cvGetRows(const CvArr* arr, CvMat* submat, int startRow, int endRow)
# ------------------------------------------------------------

if (1) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (10, 10);
	my $submat = $src->GetRows;
	$src->set([$y0, $x0], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y0, $x0]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (2) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (10, 10);
	my $submat = Cv::Mat->new($src->sizes, $src->type, undef);
	$src->GetRows($submat);
	$src->set([$y0, $x0], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y0, $x0]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (3) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (0, 10);
	my $submat = $src->GetRows($y0, $y0 + 160);
	my ($x1, $y1) = (10, 10);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (4) {
	my $src = Cv::Image->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (0, 10);
	my $submat = $src->GetRows($y0, $y0 + 160);
	my ($x1, $y1) = (10, 10);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (5) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (0, 20);
	my $submat = $src->GetRows($y0, $y0 + 160);
	my ($x1, $y1) = (30, 20);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (6) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (0, 30);
	my $submat = $src->GetRows($y0);
	my ($x1, $y1) = (0, 0);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (7) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (0, 30);
	my $submat = $src->GetRows(
		$src->new([80, 1], $src->type, undef), $y0, $y0 + 80);
	my ($x1, $y1) = (0, 10);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}

if (8) {
	my $src = Cv::Mat->new([240, 320], CV_8UC3);
	my ($x0, $y0) = (0, 30);
	my $submat = $src->GetRows($y0, $y0 + 80, 2);
	my ($x1, $y1) = (0, 2);
	$src->set([$y0 + $y1, $x0 + $x1], my $v1 = [1, 2, 3]);
	my $v2 = $submat->get([$y1/2, $x1]);
	is($v1->[$_], $v2->[$_]) for 0 .. $src->channels - 1;
}


SKIP: {
	skip("need v2.2.0+", 2) unless cvVersion() >= 2.002000;
	Cv->setErrMode(1);
	my $can_hook = Cv->getErrMode() == 1;
	$can_hook = 0 if $^O eq 'cygwin';
	Cv->setErrMode(0);
	skip("can't hook cv:error", 2) unless $can_hook;

	if (11) {
		my $src = Cv::Mat->new([240, 320], CV_8UC3);
		my $submat = eval { $src->GetRows(10, 10) };
		ok(!$@);
	}

	if (12) {
		my $src = Cv::Mat->new([240, 320], CV_8UC3);
		my $submat = eval { $src->GetRows(10, 0) };
		ok($@);
	}

}
