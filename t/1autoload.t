# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 12;
BEGIN {
	use_ok('Cv', -more);
}

our $line;

sub err_is {
	our $line;
	my $m = shift;
	chomp(my $e = $@);
	$e =~ s/\.$//;
	unshift(@_, $e, "$m at $0 line $line");
	goto &is;
}

if (1) {
	$line = __LINE__; eval { Cv->NotDefined() };
	err_is("can't call Cv::NotDefined");
}

if (2) {
	{ package Cv; sub Foo { } }
	$line = __LINE__; eval { Cv->FOO() };
	err_is("can't call Cv::FOO");
	$line = __LINE__; eval { Cv->Foo() };
	is($@, '');
	$line = __LINE__; eval { Cv->foo() };
	is($@, '');
	$line = __LINE__; eval { Cv->fOO() };
	err_is("can't call Cv::fOO");
}

if (3) {
	{ package Cv; sub BAR { } }
	$line = __LINE__; eval { Cv->BAR() };
	is($@, '');
	$line = __LINE__; eval { Cv->Bar() };
	err_is("can't call Cv::Bar");
	$line = __LINE__; eval { Cv->bar() };
	is($@, '');
	$line = __LINE__; eval { Cv->bAR() };
	is($@, '');
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
