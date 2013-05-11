# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More;
use Test::Exception;
BEGIN { use_ok('Cv') }
use File::Basename;

if (1) {
	my $mser = Cv->MSER(-delta => 1);
	is($mser->{delta}, 1);
}

