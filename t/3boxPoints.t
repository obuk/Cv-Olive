# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 24;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

sub xy {
	sprintf("(%d, %d)", map { ref $_ ? @$_ : $_ } @_);
}

sub round_array {
	for (@_) {
		$_ = int($_ + 0.5) for @$_;
	}
	@_;
}

sub Sort {
	my @pts = sort {
		$a->[1] <=> $b->[1] || $a->[0] <=> $b->[0]
	} round_array(@_);
	@pts[0, 1, 3, 2];
}

if (1) {
	my @xy = Sort( [ 1, 1 ], [ 0, 1 ], [ 1, 0 ], [ 0, 0 ] );
	ok(xy($xy[0]), xy([ 0, 0 ]));
	ok(xy($xy[1]), xy([ 1, 0 ]));
	ok(xy($xy[2]), xy([ 1, 1 ]));
	ok(xy($xy[3]), xy([ 0, 1 ]));
}

if (2) {
	# my @p0 = Cv::cvBoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	Cv::cvBoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p0);
	my @p = Sort(@$p0);
	ok(xy($p[0]) eq xy(0, 0));
	ok(xy($p[1]) eq xy(2, 0));
	ok(xy($p[2]) eq xy(2, 2));
	ok(xy($p[3]) eq xy(0, 2));
}

if (3) {
	my @p0 = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	my @p = Sort(@p0);
	ok(xy($p[0]) eq xy(0, 0));
	ok(xy($p[1]) eq xy(2, 0));
	ok(xy($p[2]) eq xy(2, 2));
	ok(xy($p[3]) eq xy(0, 2));
}

if (4) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], \my @p0);
	my @p = Sort(@p0);
	ok(xy($p[0]) eq xy(0, 0));
	ok(xy($p[1]) eq xy(2, 0));
	ok(xy($p[2]) eq xy(2, 2));
	ok(xy($p[3]) eq xy(0, 2));
}

if (5) {
	Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ], my $p0);
	my @p = Sort(@$p0);
	ok(xy($p[0]) eq xy(0, 0));
	ok(xy($p[1]) eq xy(2, 0));
	ok(xy($p[2]) eq xy(2, 2));
	ok(xy($p[3]) eq xy(0, 2));
}

if (6) {
	my $p = Cv->BoxPoints([ [ 1, 1 ], [ 2, 2 ], 90.0 ]);
	is(ref $p, 'ARRAY');
	# ok(!ref $p->[0]);			# Cv 0.16
	ok(ref $p->[0]);			# Cv 0.16
}

if (9) {
	eval { Cv->boxPoints(); };
	ok($@);
}
