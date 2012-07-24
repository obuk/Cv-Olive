# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 3;
BEGIN { use_ok('Cv') }

SKIP: {
	skip('can\'t call GetBuildInformation', 2)
		unless Cv->GetBuildInformation();
	is(scalar Cv->hasModule('core'), 1);
	is(scalar Cv->hasModule('Core'), 0);
}

package Cv;

our %OpenCV_modules;

sub HasModule {
	unless (%OpenCV_modules) {
		my %x = ();
		for (Cv->GetBuildInformation()) {
			my $g = '';
			for (split(/\n/)) {
				s/^\s+//;
				s/\s+$//;
				if (s/([^\:]+):\s*//) {
					my $k = $1;
					if (/^$/) {
						$g = $k;
					} elsif ($g) {
						$x{$g}{$k} = $_;
					} else {
						$x{$k} = $_;
					}
				} else {
					$g = undef;
				}
			}
		}
		my $m = $x{q(OpenCV modules)};
		$OpenCV_modules{$_}++ for split(/\s+/, $m->{'To be built'});
		$OpenCV_modules{$_} = undef for split(/\s+/, $m->{Disabled});
		$OpenCV_modules{$_} = undef for split(/\s+/, $m->{Unavailable});
	}
	grep { $OpenCV_modules{$_} } @_ ? @_ : keys %OpenCV_modules;
}

1;
