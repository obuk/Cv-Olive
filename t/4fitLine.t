# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 11;
# use List::Util qw(sum min max);

BEGIN {
	use_ok('Cv 0.15');
}

if (1) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	$points->FitLine(CV_DIST_L2, 0, 0.01, 0.01, my $line);
	my ($vx, $vy, $x0, $y0) = @$line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (2) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	$points->FitLine(CV_DIST_L2, 0, 0.01, 0.01, \my @line);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (3) {
	Cv->FitLine([[1, 2], [2, 3], [3, 4]], CV_DIST_L2, 0, 0.01, 0.01, \my @line);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
}

if (4) {
	Cv->FitLine([[1, 2, 1], [2, 3, 1.5], [3, 4, 2]], CV_DIST_L2, my $line);
	my ($vx, $vy, $vz, $x0, $y0, $z0) = @$line;
	cmp_ok(abs(1.0 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs(0.5 - ($vz / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
	cmp_ok(abs($z0 - ($vz / $vx) * $x0), '<', 1 + 1e-6);
}
