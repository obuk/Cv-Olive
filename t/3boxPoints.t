# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 24;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

if (1) {
	Cv::cvBoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	is_deeply_rounding($p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (2) {
	my @p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is_deeply_rounding([@p], [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (4) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], \my @p);
	is_deeply_rounding([@p], [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (5) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	is_deeply_rounding($p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (6) {
	my $p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is_deeply_rounding($p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (10) {
	e { Cv->boxPoints() };
	err_is('Cv::cvBoxPoints: box is not of type CvBox2D');
}
