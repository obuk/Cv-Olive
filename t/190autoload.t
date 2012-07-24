# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 6;
use Cv;

my $at;
eval {
	$at = sprintf("at %s line %d.", __FILE__, __LINE__ + 1);
	Cv->NotDefined();
};
# warn "\$@: $@\n";
# warn "\$at: $at\n";
like($@, qr/$at/);
