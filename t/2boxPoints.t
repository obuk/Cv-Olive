# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

if (1) {
	Cv::cvBoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	is_deeply({ round => '%.0f', rotate => 1 },
			  $p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (2) {
	my @p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is_deeply({ round => '%.0f', rotate => 1 },
			  \@p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (4) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], \my @p);
	is_deeply({ round => '%.0f', rotate => 1 },
			  \@p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (5) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	is_deeply({ round => '%.0f', rotate => 1 },
			  $p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (6) {
	my $p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is_deeply({ round => '%.0f', rotate => 1 },
			  $p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (10) {
	e { cvBoxPoints() };
	err_is('Usage: Cv::cvBoxPoints(box, pts)');
}

if (11) {
	e { cvBoxPoints([], my $pts) };
	err_is('box is not of type CvBox2D in Cv::cvBoxPoints');
}
