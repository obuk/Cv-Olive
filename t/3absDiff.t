# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 15;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

# ------------------------------------------------------------
# void cvAbsDiff(const CvArr* src1, const CvArr* src2, CvArr* dst)
# void cvAbsDiffS(const CvArr* src, CvScalar value, CvArr* dst)
# ------------------------------------------------------------

my $src = Cv::Mat->new([ 3, 3 ], CV_8UC3);

if (11) {
	my $src2 = $src->new;
	$src->fill([ 21, 22, 23, 24 ]);
	$src2->fill([ 11, 12, 13, 14 ]);
	$src->absDiff($src2, my $dst = $src->new);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}

if (12) {
	my $src2 = $src->new;
	$src->fill([ 21, 22, 23, 24 ]);
	$src2->fill([ 11, 12, 13, 14 ]);
	my $dst = $src->absDiff($src2);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}

if (21) {
	$src->fill([ 21, 22, 23, 24 ]);
	my $value = [ 11, 12, 13, 14 ];
	$src->absDiff($value, my $dst = $src->new);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}

if (22) {
	$src->fill([ 21, 22, 23, 24 ]);
	my $value = [ 11, 12, 13, 14 ];
	my $dst = $src->absDiff($value);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}


SKIP: {
	skip("need v2.0.0+", 2) unless cvVersion() >= 2.000000;
	Cv->setErrMode(1);
	my $can_hook = Cv->getErrMode() == 1;
	$can_hook = 0 if $^O eq 'cygwin';
	Cv->setErrMode(0);
	skip("can't hook cv:error", 2) unless $can_hook;

	# broken new
	if (31) {
		my $src2 = $src->new;
		$src->fill([ 21, 22, 23, 24 ]);
		$src2->fill([ 11, 12, 13, 14 ]);
		no warnings 'redefine';
		local *Cv::Mat::new = sub { undef };
		eval { $src->absDiff($src2) };
		like($@, qr/dst is not of type CvArr/);
	}

	# OpenCV Error:
	if (32) {
		my $src2 = $src->new;
		$src->fill([ 21, 22, 23, 24 ]);
		$src2->fill([ 11, 12, 13, 14 ]);
		eval { $src->absDiff($src2, \0) };
		like($@, qr/OpenCV Error:/);
	}
}

