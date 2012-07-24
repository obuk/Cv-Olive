# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}


my $stor = Cv::MemStorage->new();
ok($stor->isa('Cv::MemStorage'));

if (1) {
	my $hw = "hello, world";
	my $s = $stor->allocString($hw);
	ok($s->isa('Cv::String'), "allocString");
	ok($s->can('ptr'), 'can(ptr)');
	is($s->ptr, $hw, 'ptr');
	ok($s->can('len'), 'can(len)');
	is($s->len, length($hw), "len");
}

if (2) {
	my $hw = "\0hello, world";
	my $s = $stor->allocString($hw);
	ok($s->isa('Cv::String'), "allocString");
	ok($s->can('ptr'), 'can(ptr)');
	is($s->ptr, $hw, 'ptr');
	ok($s->can('len'), 'can(len)');
	is($s->len, length($hw), "len");
}
