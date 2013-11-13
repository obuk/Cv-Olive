# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More;
BEGIN {
	eval "use Test::Number::Delta within => 1e-7";
	if ($@) {
		plan skip_all => "Test::Number::Delta";
	} else {
		plan tests => 5;
	}
}
BEGIN { use_ok('Cv', -nomore) }

# ------------------------------------------------------------
#  void cvDiv(CvArr* src1, CvArr* src2, CvArr* dst, double scale=1)
# ------------------------------------------------------------

my $src1 = Cv::Mat->new([ 3 ], CV_32FC1);

{
	my $src2 = $src1->new;
	$src1->set([0], [rand]);
	$src1->set([1], [rand]);
	$src1->set([2], [rand]);
	$src2->set([0], [1 + rand]);
	$src2->set([1], [1 + rand]);
	$src2->set([2], [1 + rand]);
	my $dst = $src1->div($src2);
	delta_ok(
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

{
	my $src2 = $src1->new;
	$src1->set([0], [rand]);
	$src1->set([1], [rand]);
	$src1->set([2], [rand]);
	$src2->set([0], [1 + rand]);
	$src2->set([1], [1 + rand]);
	$src2->set([2], [1 + rand]);
	$src1->div($src2, my $dst = $src1->new);
	delta_ok(
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


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	throws_ok { $src1->Div(0, 0, 0, 0) } qr/Usage: Cv::Arr::cvDiv\(src1, src2, dst, scale=1\) at $0/;
	throws_ok { $src1->Div(\0) } qr/OpenCV Error:/;
}

sub Div {
	my ($a, $b) = @_;
	$a / $b;
}
