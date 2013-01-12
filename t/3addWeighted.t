# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 3;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

use File::Basename;
my $verbose = Cv->hasGUI;

# ------------------------------------------------------------
# void cvAddWeighted(const CvArr* src1, double alpha, const CvArr* src2, double beta, double gamma, CvArr* dst)
# ------------------------------------------------------------

if (10) {
	e { Cv::Arr::cvAddWeighted() };
	err_is('Usage: Cv::Arr::cvAddWeighted(src1, alpha, src2, beta, gamma, dst)');
}

my $src1 = Cv->loadImage(dirname($0) . "/baboon.jpg");
my $src2 = Cv->loadImage(dirname($0) . "/lena.jpg");

if (11) {
	e { $src1->addWeighted(0, $src2->cvtColor(CV_BGR2GRAY), 0, 0) };
	err_like('OpenCV Error:');
}

my $win = "addWeighted";
my ($minbar, $maxbar) = (0, 50);

if ($verbose) {
	Cv->namedWindow($win, 0);
	Cv->createTrackbar("alpha", $win, $minbar, $maxbar, \&onChange);
}

sub onChange {
	my $alpha = $_[0] || 0;
	$alpha /= $maxbar;
	my ($beta, $gamma) = (1.0 - $alpha, 0);
	my $added = $src1->addWeighted($alpha, $src2, $beta, $gamma);
	if ($verbose) {
		$added->show($win);
	}
}

&onChange;
foreach (($minbar) x 30, $minbar .. $maxbar, ($maxbar) x 30) {
	if ($verbose) {
		Cv->setTrackbarPos("alpha", $win, $_);
		my $c = Cv->waitKey(33);
		last if ($c > 0 && ($c & 0xff) == 27);
	}
}
