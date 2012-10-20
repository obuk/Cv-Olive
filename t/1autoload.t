# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 12;
BEGIN {
	use_ok('Cv', qw(:nomore));
}

if (1) {
	my $at;
	eval {
		$at = sprintf("at %s line %d.", __FILE__, __LINE__ + 1);
		Cv->NotDefined();
	};
	# warn "\$@: $@\n";
	# warn "\$at: $at\n";
	like($@, qr/Cv::AUTOLOAD can't call Cv::NotDefined $at/);
}

if (2) {
	{ package Cv; sub Foo { die "ok" } }
	eval { Cv->FOO() };
	like($@, qr/can't/);
	eval { Cv->Foo() };
	like($@, qr/^ok at/);
	eval { Cv->foo() };
	like($@, qr/^ok at/);
	eval { Cv->fOO() };
	like($@, qr/can't/);
}

if (3) {
	{ package Cv; sub BAR { die "ok" } }
	eval { Cv->BAR() };
	like($@, qr/^ok at/);
	eval { Cv->Bar() };
	like($@, qr/can't/);
	eval { Cv->bar() };
	like($@, qr/^ok at/);
	eval { Cv->bAR() };
	like($@, qr/^ok at/);
}

if (4) {
	eval { Cv->cvmGet() };
	like($@, qr/can't/);
}

if (5) {
	my $cv = bless [], 'Cv';
	eval { $cv->alloc() };
	like($@, qr/class name needed at/);
}
