# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 2;
use Cv qw(/^cv/);

my $at;
eval {
	$at = sprintf("at %s line %d.", __FILE__, __LINE__ + 1);
	cvCreateImage();
};
# warn $@;
like($@, qr/^Usage:/);
like($@, qr/$at/);
