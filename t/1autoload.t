# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 12;
BEGIN {
	use_ok('Cv', -more);
}

our $line;

if (1) {
	eval { Cv->NotDefined() }; $line = __LINE__;
	err_is("can't call Cv::NotDefined");
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
	$line = __LINE__; eval { Cv->cvmGet() };
	err_is("can't call Cv::cvmGet");
}

if (5) {
	my $cv = bless [], 'Cv';
	$line = __LINE__; eval { $cv->alloc() };
	err_is("class name needed");
}

sub err_is {
	our $line;
	my $m = shift;
	chomp(my $e = $@);
	$e =~ s/\.$//;
	unshift(@_, $e, "$m at $0 line $line");
	goto &is;
}
