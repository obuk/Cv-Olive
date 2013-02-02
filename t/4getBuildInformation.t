# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 4;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv') }

SKIP: {
	skip('version 2.4.0+', 3)
		unless Cv->version >= 2.004;
	skip('can\'t call GetBuildInformation', 3)
		unless Cv->assoc('GetBuildInformation') && Cv->GetBuildInformation;
	is(scalar Cv->hasModule('core'), 1);
	is(scalar Cv->hasModule('Core'), 0);
	diag("OpenCV modules: ", join(", ", Cv->hasModule));
	e { Cv->fontQt };
	err_is("no Qt");
}
