# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 10;
use Data::Dumper;

BEGIN {
	chop(my $ccflags = eval { `pkg-config opencv` });
	is($?, 0, "can pkg-config opencv");
	use_ok('Cv::Config');
}

if (1) {
	no warnings;
	local $Data::Dumper::Terse = 1;
	local $Cv::Config::cf = undef;
	undef *{Cv::Config::cf};
	undef $ENV{CC}, $ENV{CXX};
	my $cf = eval { new Cv::Config };
	like($cf->cvdir, qr{/blib/lib/Cv});
	like(${$cf->typemaps}[0], qr{/blib/lib/Cv/typemap});
	is($cf->cc, 'c++');
	ok($cf->version >= 1.001);
	like($cf->myextlib, qr{/blib/arch/auto/Cv/Cv.(dll|so)});
}

if (2) {
	no warnings;
	local $Data::Dumper::Terse = 1;
	local $Cv::Config::cf = undef;
	my $dynamic_lib = 0;
	my @cxx = ();
	for my $cxx (qw(c++ g++ g++-4 g++44 g++45 g++46)) {
		local *STDERR_COPY;
		open(STDERR_COPY, '>&STDERR');
		open(STDERR, '/dev/null');
		eval { `$cxx -v` };
		my $r = $?;
		open(STDERR, '>&STDERR_COPY');
		next unless $r == 0;
		push(@cxx, $cxx);
		delete $ENV{CC};
		$ENV{CXX} = $cxx;
		undef *{Cv::Config::cf};
		my $cf = eval { new Cv::Config };
		$dynamic_lib++ if $cf->dynamic_lib;
	}
	is($dynamic_lib, scalar @cxx);
	diag("cxx: ", join(' ', @cxx));
}

if (3) {
	no warnings;
	local $Data::Dumper::Terse = 1;
	local $Cv::Config::cf = undef;
	local %Cv::Config::opencv = ();
	my $include = '/path/to/include';
	my $define = 'define=something';
	$Cv::Config::opencv{cflags} = "-I$include -D$define";
	undef *{Cv::Config::cf};
	my $cf = eval { new Cv::Config };
	like($cf->ccflags, qr{-I$include});
	like($cf->ccflags, qr{-D$define});
}
