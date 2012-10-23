# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 32;

BEGIN {
	use_ok('Cv');
	use_ok('Cv::Seq::SURFPoint');
}

my $stor = Cv::MemStorage->new;

if (1) {
	my $seq = bless Cv::Seq->new(0, 0, 4 * 6), 'Cv::Seq::SURFPoint';

	$seq->push([[ 1, 2 ], 3, 4, 5, 6]);
	my $x = $seq->pop;
	is($x->[0]->[0], 1);
	is($x->[0]->[1], 2);
	is($x->[1], 3);
	is($x->[2], 4);
	is($x->[3], 5);
	is($x->[4], 6);

	$seq->push([[ 11, 12 ], 13, 14, 15, 16 ],
			   [[ 21, 22 ], 23, 24, 25, 26 ],
		);

	my @x = $seq->toArray;
	is($x[0]->[0]->[0], 11);
	is($x[0]->[0]->[1], 12);
	is($x[0]->[1], 13);
	is($x[0]->[2], 14);
	is($x[0]->[3], 15);
	is($x[0]->[4], 16);
	is($x[1]->[0]->[0], 21);
	is($x[1]->[0]->[1], 22);
	is($x[1]->[1], 23);
	is($x[1]->[2], 24);
	is($x[1]->[3], 25);
	is($x[1]->[4], 26);

	@x = @$seq;
	is($x[0]->[0]->[0], 11);
	is($x[0]->[0]->[1], 12);
	is($x[0]->[1], 13);
	is($x[0]->[2], 14);
	is($x[0]->[3], 15);
	is($x[0]->[4], 16);
	is($x[1]->[0]->[0], 21);
	is($x[1]->[0]->[1], 22);
	is($x[1]->[1], 23);
	is($x[1]->[2], 24);
	is($x[1]->[3], 25);
	is($x[1]->[4], 26);
}
