# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 13;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

my $stor = Cv::MemStorage->new();
ok($stor->isa('Cv::MemStorage'));

if (1) {
	my $hw = "hello, world";
	my $s = $stor->allocString($hw);
	isa_ok($s, 'Cv::String');
	can_ok($s, 'ptr');
	is($s->ptr, $hw);
	can_ok($s, 'len');
	is($s->len, length($hw));
}

if (2) {
	my $hw = "\0hello, world";
	my $s = $stor->allocString($hw);
	isa_ok($s, 'Cv::String');
	can_ok($s, 'ptr');
	is($s->ptr, $hw);
	can_ok($s, 'len');
	is($s->len, length($hw));
}

if (10) {
	e { $stor->allocString() };
	err_is("Usage: Cv::MemStorage::cvAllocString(storage, ptr, len=-1)");
}
