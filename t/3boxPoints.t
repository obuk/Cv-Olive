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
	is_round_deeply('%.0f', p4sort($p), [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (2) {
	my @p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is_round_deeply('%.0f', p4sort(\@p), [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (4) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], \my @p);
	is_round_deeply('%.0f', p4sort(\@p), [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (5) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	is_round_deeply('%.0f', p4sort($p), [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (6) {
	my $p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is_round_deeply('%.0f', p4sort($p), [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

if (10) {
	e { cvBoxPoints() };
	err_is('Usage: Cv::cvBoxPoints(box, pts)');
}

if (11) {
	e { cvBoxPoints([], my $pts) };
	err_is('box is not of type CvBox2D in Cv::cvBoxPoints');
}


sub p4sort {
	my @pts = sort { $a->[1] <=> $b->[1] || $a->[0] <=> $b->[0] } @{$_[0]};
	[ @pts[0,1,3,2] ];
}
