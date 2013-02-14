# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 13;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

if (1) {
	e { Cv->NotDefined() };
	err_is("can't call Cv::NotDefined");
}

if (2) {
	{ package Cv; sub Foo { } }
	e { Cv->FOO() };
	err_is("can't call Cv::FOO");
	e { Cv->Foo() };
	err_is('');
	e { Cv->foo() };
	err_is('');
	e { Cv->fOO() };
	err_is("can't call Cv::fOO");
}

if (3) {
	{ package Cv; sub BAR { } }
	e { Cv->BAR() };
	err_is('');
	e { Cv->Bar() };
	err_is("can't call Cv::Bar");
	e { Cv->bar() };
	err_is('');
	e { Cv->bAR() };
	err_is('');
}

if (4) {
	e { Cv->cvmGet() };
	err_is("can't call Cv::cvmGet");
}

if (5) {
	my $cv = bless [], 'Cv';
	e { $cv->alloc() };
	err_is("class name needed");
}
