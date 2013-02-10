# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 4;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -more) }

my $verbose = Cv->hasGUI;

# ------------------------------------------------------------
#  void cvDCT(const CvArr* src, CvArr* dst, int flags)
# ------------------------------------------------------------

my $src = Cv::Mat->new([100, 100], CV_64FC1);
for my $i (0 .. $src->rows - 1) {
	for my $j (0 .. $src->cols - 1) {
		my ($x, $y) = ($i / $src->rows, $j / $src->cols);
		$src->set([$i, $j], [sqrt($x * $x + $y * $y)]);
	}
}

if (1) {
	my $dct = $src->DCT(CV_DXT_INVERSE);
	if ($verbose) {
		$dct->show("dct");
		Cv->waitKey(1000);
	}
}

if (2) {
	my $dct = $src->DCT($src->new, CV_DXT_INVERSE);
	if ($verbose) {
		$dct->show("dct");
		Cv->waitKey(1000);
	}
}

if (10) {
	e { $src->DCT() };
	err_is("Usage: Cv::Arr::cvDCT(src, dst, flags)");
}

if (11) {
	e { $src->DCT(\0, CV_DXT_FORWARD) };
	err_like("OpenCV Error:");
}
