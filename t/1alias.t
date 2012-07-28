# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 11;
use Cv;

{
	package Cv::Something;
	sub cvSubroutineA { unshift(@_, 'a'); @_ }
	Cv::alias qw(SubroutineA SubrA SubA);
	sub SubroutineB { unshift(@_, 'b'); @_ }
	Cv->alias(qw(SubroutineB SubrB SubB));
}

if (1) {
	my @x = Cv::Something->subrA('x');
	is($x[0], 'a');
	is($x[1], 'Cv::Something');
	is($x[2], 'x');
}

if (2) {
	my @x = Cv::Something->subB('y');
	is($x[0], 'b');
	is($x[1], 'Cv::Something');
	is($x[2], 'y');
}

if (3) {
	{ package Cv; Cv::alias(qw(Foo)) }
	eval { Cv->Foo() };
	like($@, qr/TBD/);
	eval { Cv->foo() };
	like($@, qr/TBD/);
}

if (4) {
	{ package Cv; Cv::alias(qw(Bar), sub { die "xxx" }) }
	eval { Cv->Bar() };
	like($@, qr/^xxx at/);
	eval { Cv->bar() };
	like($@, qr/^xxx at/);
}

if (4) {
	is(&Cv::alias(), undef);
}
