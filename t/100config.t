# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

use Data::Dumper;
# use Config;

BEGIN {
	my $no_OpenCV;
	if (fork) {
		wait;
		$no_OpenCV = ($? >> 8) == 1;
	} else {
		local %ENV;
		delete $ENV{PATH};
		open(STDERR, "/dev/null");
		use_ok('Cv::Config');
		exit 0;
	}
	ok($no_OpenCV, "no OpenCV");
	use_ok('Cv::Config');
}


if (1) {
	no warnings;
	local $Data::Dumper::Terse = 1;
	local $Cv::Config::cf = undef;
	local $Cv::Config::verbose = undef;
	undef *{Cv::Config::cf};
	# undef *{Cv::cvVersion};
	undef $ENV{CC}, $ENV{CXX};
	my $cf = eval { new Cv::Config };
	like($cf->cvdir, qr{/blib/lib/Cv});
	like(${$cf->typemaps}[0], qr{/blib/lib/Cv/typemap});
	is($cf->cc, 'c++');
	if (0) {
		chop(my $libs = eval { `pkg-config opencv --libs` });
		my %L; my @libs = map {
			/(.*)[\/\\]lib(.*)\.\w+$/; $L{$1}++; "-l$2";
		} grep(/\.(a|so|dll)$/, split(/\s+/, $libs));
		unshift(@libs, "-L${[ keys %L ]}[0]");
		is(join(" ", @{$cf->libs}), join(" ",@libs));
	}
	#is(${$cf->dynamic_lib}{OTHERLDFLAGS}, undef);
	chop(my $ccflags = eval { `pkg-config opencv --cflags` });
	like($cf->ccflags, qr{-I/usr/local/include});
	ok($cf->version >= 1.001);
	like($cf->myextlib, qr{/blib/arch/auto/Cv/Cv.(dll|so)});
}

if (4) {
	no warnings;
	local $Data::Dumper::Terse = 1;
	local $Cv::Config::cf = undef;
	local $Cv::Config::verbose = undef;
	for my $cpp (qw(c++ g++ g++-4 g++44 g++45 g++46)) {
		local *STDERR_COPY;
		open(STDERR_COPY, '>&STDERR');
		open(STDERR, '/dev/null');
		eval { `$cpp -v` };
		next unless ($? == 0);
		open(STDERR, ">&STDERR_COPY");
		delete $ENV{CC};
		$ENV{CXX} = $cpp;
		undef *{Cv::Config::cf};
		my $cf = eval { new Cv::Config };
		ok($cf->dynamic_lib);
	}
}

if (5) {
	no warnings;
	local $Data::Dumper::Terse = 1;
	local $Cv::Config::cf = undef;
	local $Cv::Config::verbose = undef;
	local %Cv::Config::opencv = ();
	# undef *{Cv::cvVersion};
	my $include = '/path/to/include';
	my $define = 'define=something';
	$Cv::Config::opencv{cflags} = "-I$include -D$define";
	undef *{Cv::Config::cf};
	my $cf = eval { new Cv::Config };
	like($cf->ccflags, qr{-I$include});
	like($cf->ccflags, qr{-D$define});
}
