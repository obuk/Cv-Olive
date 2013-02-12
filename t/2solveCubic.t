# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
BEGIN { use_ok('Cv::T') };
BEGIN { use_ok('Cv', -more) }

if (1) {
	# http://keisan.casio.jp/has10/SpecExec.cgi
	my $coeffs = Cv::Mat->new([4], CV_64FC1);
	my $roots = Cv::Mat->new([3], CV_64FC1);
	$coeffs->set([0], [  1]);
	$coeffs->set([1], [ -2]);
	$coeffs->set([2], [-11]);
	$coeffs->set([3], [ 12]);
	my $n = $coeffs->SolveCubic($roots);
	is($n, 3);
	my @x = sort(map { $roots->getReal($_) } 0 .. $n - 1);
	is($x[0], -3);
	is($x[1],  1);
	is($x[2],  4);
}

if (10) {
	my $coeffs = Cv::Mat->new([4], CV_64FC1);
	e { $coeffs->solveCubic };
	err_is("Usage: Cv::Arr::cvSolveCubic(coeffs, roots)");
}

if (11) {
	my $coeffs = Cv::Mat->new([4], CV_64FC1);
	my $roots = Cv::Mat->new([1], CV_64FC1);
	e { $coeffs->solveCubic($roots) };
	err_like("OpenCV Error:");
}
