# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 6;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
#  void cvDiv(CvArr* src1, CvArr* src2, CvArr* dst, double scale=1)
# ------------------------------------------------------------

my $src1 = Cv::Mat->new([ 3 ], CV_32FC1);

if (1) {
	my $src2 = $src1->new;
	$src1->set([0], [rand]);
	$src1->set([1], [rand]);
	$src1->set([2], [rand]);
	$src2->set([0], [1 + rand]);
	$src2->set([1], [1 + rand]);
	$src2->set([2], [1 + rand]);
	my $dst = $src1->div($src2);
	is_({ round => "%.4g" },
		[ $dst->getReal(0),
		  $dst->getReal(1),
		  $dst->getReal(2),
		],
		[ Div($src1->getReal(0), $src2->getReal(0)),
		  Div($src1->getReal(1), $src2->getReal(1)),
		  Div($src1->getReal(2), $src2->getReal(2)),
		],
		);
}

if (2) {
	my $src2 = $src1->new;
	$src1->set([0], [rand]);
	$src1->set([1], [rand]);
	$src1->set([2], [rand]);
	$src2->set([0], [1 + rand]);
	$src2->set([1], [1 + rand]);
	$src2->set([2], [1 + rand]);
	$src1->div($src2, my $dst = $src1->new);
	is_({ round => "%.4g" },
		[ $dst->getReal(0),
		  $dst->getReal(1),
		  $dst->getReal(2),
		],
		[ Div($src1->getReal(0), $src2->getReal(0)),
		  Div($src1->getReal(1), $src2->getReal(1)),
		  Div($src1->getReal(2), $src2->getReal(2)),
		],
		);
}

if (10) {
	e { $src1->Div(0, 0, 0, 0) };
	err_is("Usage: Cv::Arr::cvDiv(src1, src2, dst, scale=1)");
}

if (12) {
	e { $src1->Div(\0) }; 
	err_like("OpenCV Error:");
}

sub Div {
	my ($a, $b) = @_;
	$a / $b;
}
