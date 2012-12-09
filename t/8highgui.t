# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use utf8;

use Test::More qw(no_plan);
# use Test::More tests => 10;
BEGIN {
	use_ok('Cv', -more, -highgui);
}

ok(!Cv->hasGUI);
ok(!Cv->hasQt);
