# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 3;

BEGIN {
	use_ok('Cv', -more);
}

our %cv;
our %CLASS;

use File::Basename;
use lib dirname($0);
require "hackcv.pm";

use IO::File;
my $xs = IO::File->new(dirname($0) . "/../Cv.xs");
my $xsfixed = IO::File->new(dirname($0) . "/../Cv.xs.fixed", "w");

my $fixed;
my ($module, $package) = ('', '');
my @hunk;
while (<$xs>) {
	push(@hunk, $_);
	if ($_ =~ /^$/) {
		print $xsfixed $_ for @hunk;
		@hunk = ();
	}
	s/\#.*//;
	if (/^MODULE\s*=\s*([^\s]+)\s+PACKAGE\s*=\s*([^\s]+)\s*/) {
		($module, $package) = ($1, $2);
	}
	next unless $module;
	if (/^(cv\w+)\(.*\)/) {
		my $name = $1;
		parse_decl($hunk[-2].$hunk[-1]);
		if ($CLASS{$name} && $CLASS{$name} ne $package) {
			$package = $CLASS{$name};
			@hunk = (
				# (map { "# $_" } grep /MODULE/, @hunk),
				"MODULE = $module\tPACKAGE = $package\n",
				(grep !/MODULE/, @hunk),
				);
			$fixed++;
		}
	}
}
print $xsfixed $_ for @hunk;

if ($fixed) {
	ok(0, "check PACKAGE stmt; see Cv.xs.fixed");
} else {
	unlink "Cv.xs.fixed";
	ok(1, "PACKAGE stmt");
}

exit 0;
