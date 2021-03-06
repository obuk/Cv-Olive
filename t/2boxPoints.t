# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More;
BEGIN {
	eval "use Test::Number::Delta within => 1e-15";
	if ($@) {
		plan skip_all => "Test::Number::Delta";
	} else {
		plan tests => 8;
	}
}

BEGIN { use_ok('Cv', -nomore) }

sub box_ok {
	my ($got, $exp) = splice(@_, 0, 2);
	my $len = scalar @$exp;
	my $dim = scalar @{$exp->[0]};
	my @delta;
	for my $i (0 .. $len - 1) {
		my $delta = 0;
		for my $j (0 .. $len - 1) {
			$delta += abs($got->[($i + $j) % $len]->[$_] - $exp->[$j]->[$_])
				for 0 .. $dim - 1;
		}
		push(@delta, [$delta, $i]);
	}
	@delta = sort { $a->[0] <=> $b->[0] } @delta;
	if (my $shift = $delta[0]->[1]) {
		my @tmp = splice(@$got, 0, $shift);
		push(@$got, @tmp);
	}
	unshift(@_, $got, $exp);
	goto &Test::Number::Delta::delta_ok;
	# goto &Test::More::is_deeply;
}

{
	Cv::cvBoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	box_ok($p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

{
	my @p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	box_ok(\@p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

{
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], \my @p);
	box_ok(\@p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

{
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p);
	box_ok($p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}

{
	my $p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	box_ok($p, [ [0, 0], [2, 0], [2, 2], [0, 2] ]);
}


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	throws_ok { cvBoxPoints() } qr/Usage: Cv::cvBoxPoints\(box, pts\) at $0/;

	throws_ok { cvBoxPoints([], my $pts) } qr/box is not of type CvBox2D in Cv::cvBoxPoints at $0/;
}
