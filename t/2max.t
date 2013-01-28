# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 12;
use File::Basename;
use List::Util qw(max);
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
# void cvMax(const CvArr* src1, const CvArr* src2, CvArr* dst)
# void cvMaxS(const CvArr* src, double value, CvArr* dst)
# ------------------------------------------------------------

my $src = Cv::Mat->new([ 3 ], CV_32SC1);

if (1) {
	my $src2 = $src->new;
	$src->set([0], [int rand 1000]);
	$src->set([1], [int rand 1000]);
	$src->set([2], [int rand 1000]);
	$src2->set([0], [int rand 1000]);
	$src2->set([1], [int rand 1000]);
	$src2->set([2], [int rand 1000]);
	my $dst = $src->max($src2);
	is($dst->getReal(0), max($src->getReal(0), $src2->getReal(0)));
	is($dst->getReal(1), max($src->getReal(1), $src2->getReal(1)));
	is($dst->getReal(2), max($src->getReal(2), $src2->getReal(2)));
}

if (2) {
	$src->set([0], [int rand 1000]);
	$src->set([1], [int rand 1000]);
	$src->set([2], [int rand 1000]);
	my $value = int rand 1000;
	my $dst = $src->max($value);
	is($dst->getReal(0), max($src->getReal(0), $value));
	is($dst->getReal(1), max($src->getReal(1), $value));
	is($dst->getReal(2), max($src->getReal(2), $value));
}

if (10) {
	e { $src->max(0, 0, 0) };
	err_is("Usage: Cv::Arr::cvMaxS(src, value, dst)");
	e { $src->max($src, 0, 0) };
	err_is("Usage: Cv::Arr::cvMax(src1, src2, dst)");
}

if (11) {
	e { $src->max([1]) };
	err_is("src2 is not of type CvArr * in Cv::Arr::cvMax");
}

if (12) {
	e { $src->max(0, $src->new(CV_32FC1)) };
	err_like("OpenCV Error:");
}

if (12) {
	e { $src->max($src->new, $src->new(CV_32FC1)) };
	err_like("OpenCV Error:");
}
