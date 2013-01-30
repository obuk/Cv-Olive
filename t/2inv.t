# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
#  double cvInv(const CvArr* src, CvArr* dst, int method=CV_LU)
# ------------------------------------------------------------

if (1) {
	my $src = Cv::Mat->new([2, 2], CV_32FC1);
	$src->set([0, 0], [1]);
	$src->set([0, 1], [2]);
	$src->set([1, 0], [3]);
	$src->set([1, 1], [4]);
	my $det = $src->inv;
	is($det, $src->det);
}

if (2) {
	my $src = Cv::Mat->new([2, 2], CV_64FC1);
	my ($a, $b, $c, $d) = map { int rand 10 } 1 .. 4;
	$src->set([0, 0], [$a]);
	$src->set([0, 1], [$b]);
	$src->set([1, 0], [$c]);
	$src->set([1, 1], [$d]);
	my $det = $src->invert(my $inv = $src->new);
	is($det, $src->det);
	my $D = ($a * $d - $b * $c);
	if ($D) { is($inv->getReal([0, 0]),  $d / $D) } else { ok(1) }
	if ($D) { is($inv->getReal([0, 1]), -$b / $D) } else { ok(1) }
	if ($D) { is($inv->getReal([1, 0]), -$c / $D) } else { ok(1) }
	if ($D) { is($inv->getReal([1, 1]),  $a / $D) } else { ok(1) }
}

if (10) {
	my $src = Cv::Mat->new([2], CV_32FC1);
	e { $src->inv(1, 2) };
	err_is("Usage: Cv::Arr::cvInv(src, dst, method=CV_LU)");
}

if (11) {
	my $src = Cv::Mat->new([2], CV_32FC1);
	e { $src->inv };
	err_like("OpenCV Error");
}
