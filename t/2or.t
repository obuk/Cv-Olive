# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 16;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
# void cvOr(CvArr* src1, CvArr* src2, CvArr* dst, CvArr* mask=NULL)
# void cvOrS(CvArr* src, CvScalar value, CvArr* dst, CvArr* mask=NULL)
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
	my $dst = $src->or($src2);
	is($dst->getReal(0), Or($src->getReal(0), $src2->getReal(0)));
	is($dst->getReal(1), Or($src->getReal(1), $src2->getReal(1)));
	is($dst->getReal(2), Or($src->getReal(2), $src2->getReal(2)));
}

if (2) {
	my $src2 = $src->new;
	$src->set([0], [int rand 1000]);
	$src->set([1], [int rand 1000]);
	$src->set([2], [int rand 1000]);
	$src2->set([0], [int rand 1000]);
	$src2->set([1], [int rand 1000]);
	$src2->set([2], [int rand 1000]);
	$src->or($src2, my $dst = $src->new);
	is($dst->getReal(0), Or($src->getReal(0), $src2->getReal(0)));
	is($dst->getReal(1), Or($src->getReal(1), $src2->getReal(1)));
	is($dst->getReal(2), Or($src->getReal(2), $src2->getReal(2)));
}

if (3) {
	$src->set([0], [int rand 1000]);
	$src->set([1], [int rand 1000]);
	$src->set([2], [int rand 1000]);
	my $value = int rand 1000;
	my $dst = $src->or([$value]);
	is($dst->getReal(0), Or($src->getReal(0), $value));
	is($dst->getReal(1), Or($src->getReal(1), $value));
	is($dst->getReal(2), Or($src->getReal(2), $value));
}

if (4) {
	$src->set([0], [int rand 1000]);
	$src->set([1], [int rand 1000]);
	$src->set([2], [int rand 1000]);
	my $value = int rand 1000;
	$src->or([$value], my $dst = $src->new);
	is($dst->getReal(0), Or($src->getReal(0), $value));
	is($dst->getReal(1), Or($src->getReal(1), $value));
	is($dst->getReal(2), Or($src->getReal(2), $value));
}

if (10) {
	e { $src->or(0, 0, 0, 0) };
	err_is("Usage: Cv::Arr::cvOr(src1, src2, dst, mask=NULL)");
}

if (12) {
	e { $src->or(\0) }; 
	err_like("OpenCV Error:");
}


sub Or {
	my $x = shift;
	$x |= $_ for @_;
	$x;
}
