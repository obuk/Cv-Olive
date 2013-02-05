# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 5;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

# ------------------------------------------------------------
#  void cvMul(CvArr* src1, CvArr* src2, CvArr* dst, double scale=1)
# ------------------------------------------------------------

my $src1 = Cv::Mat->new([ 3 ], CV_32FC1);

if (1) {
	my $src2 = $src1->new;
	$src1->set([0], [rand]);
	$src1->set([1], [rand]);
	$src1->set([2], [rand]);
	$src2->set([0], [rand]);
	$src2->set([1], [rand]);
	$src2->set([2], [rand]);
	my $dst = $src1->mul($src2);
	is_deeply({ round => "%.4g" },
			  [ $dst->getReal(0),
				$dst->getReal(1),
				$dst->getReal(2),
			  ],
			  [ Mul($src1->getReal(0), $src2->getReal(0)),
				Mul($src1->getReal(1), $src2->getReal(1)),
				Mul($src1->getReal(2), $src2->getReal(2)),
			  ],
		);
}

if (2) {
	my $src2 = $src1->new;
	$src1->set([0], [rand]);
	$src1->set([1], [rand]);
	$src1->set([2], [rand]);
	$src2->set([0], [rand]);
	$src2->set([1], [rand]);
	$src2->set([2], [rand]);
	$src1->mul($src2, my $dst = $src1->new);
	is_deeply({ round => "%.4g" },
			  [ $dst->getReal(0),
				$dst->getReal(1),
				$dst->getReal(2),
			  ],
			  [ Mul($src1->getReal(0), $src2->getReal(0)),
				Mul($src1->getReal(1), $src2->getReal(1)),
				Mul($src1->getReal(2), $src2->getReal(2)),
			  ],
		);
}

if (10) {
	e { $src1->Mul(0, 0, 0, 0) };
	err_is("Usage: Cv::Arr::cvMul(src1, src2, dst, scale=1)");
}

if (12) {
	e { $src1->Mul(\0) }; 
	err_like("OpenCV Error:");
}

sub Mul {
	my ($a, $b) = @_;
	$a * $b;
}
