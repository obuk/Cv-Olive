# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 5;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

my $verbose = Cv->hasGUI;

# ------------------------------------------------------------
#  void cvDFT(const CvArr* src, CvArr* dst, int flags, int nonzeroRows=0)
# ------------------------------------------------------------

my $src = Cv::Mat->new([100, 100], CV_64FC1);
for my $i (0 .. $src->rows - 1) {
	for my $j (0 .. $src->cols - 1) {
		my ($x, $y) = ($i / $src->rows, $j / $src->cols);
		$src->set([$i, $j], [sqrt($x * $x + $y * $y)]);
	}
}

if (1) {
	my $dft = $src->DFT(CV_DXT_FORWARD);
	my $re = $src->new;
	my $im = $src->new;
	for my $i (0 .. $dft->rows - 1) {
		for my $j (0 .. $dft->cols - 1) {
			my $v = $dft->get([$i, $j]);
			$re->set([$i, $j], [$v->[0]]);
			$im->set([$i, $j], [$v->[1]]);
		}
	}
	if ($verbose) {
		$im->show("dft");
		Cv->waitKey(1000);
	}
}

if (2) {
	my $dft = $src->DFT($src->new(CV_64FC2), CV_DXT_FORWARD);
	my $re = $src->new;
	my $im = $src->new;
	for my $i (0 .. $dft->rows - 1) {
		for my $j (0 .. $dft->cols - 1) {
			my $v = $dft->get([$i, $j]);
			$re->set([$i, $j], [$v->[0]]);
			$im->set([$i, $j], [$v->[1]]);
		}
	}
	if ($verbose) {
		$im->show("dft");
		Cv->waitKey(1000);
	}
}

if (10) {
	e { $src->DFT() };
	err_is("Usage: Cv::Arr::cvDFT(src, dst, flags, nonzeroRows=0)");
}

if (11) {
	e { $src->DFT(\0, CV_DXT_FORWARD) };
	err_like("OpenCV Error:");
}
