# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 60;
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

ok(!defined $Cv::Constant::{AUTOLOAD});
ok(!defined $Cv::Image::Ghost::{AUTOLOAD});
ok(!defined $Cv::Mat::Ghost::{AUTOLOAD});
ok(!defined $Cv::MatND::Ghost::{AUTOLOAD});
ok(!defined $Cv::More::{AUTOLOAD});
ok(!defined $Cv::SparseMat::Ghost::{AUTOLOAD});

for (&classes('Cv')) {
	next if /^Cv::.*::Ghost$/;
	next if /^Cv::(Constant|More|Test)$/;
	# next if /^Cv::Seq/;
	my $AUTOLOAD = "${_}::AUTOLOAD";
	is(\&{$AUTOLOAD}, \&Cv::autoload, $_);
}

sub classes {
	my @list = ();
	my $name = shift;
	my $class = eval "\\%${name}::";
	if (ref $class eq 'HASH') {
		for (keys %$class) {
			if (/^(\w+)::$/) {
				push(@list, &classes("${name}::$1"));
			}
		}
		push(@list, $name);
	}
	@list;
}
