#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;

sub d {
	my $name = shift;
	my $ref = eval "\\%$name";
	for (keys %$ref) {
		d($name . $_) if /^\w+::$/;
		my $p = $ref->{$_};
		next unless my $code = eval "${p}{CODE}";
		print "$_ $name\n" if /^cv[mA-Z]/;
		# print "$_ $name\n" if /^CV_)/;
	}
}

&d(q(Cv::));
