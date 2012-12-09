# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 4;

BEGIN {
	use_ok('Cv');
}

our $line;
sub err_is {
	our $line;
	chop(my $a = $@);
	my $b = "$_[0] at $0 line $line";
	$b .= '.' if $a =~ m/\.$/;
	unshift(@_, "$a\n", "$b\n");
	goto &is;
}

SKIP: {
	skip('version 2.4.0+', 3)
		unless Cv->version >= 2.004;
	skip('can\'t call GetBuildInformation', 3)
		unless Cv->assoc('GetBuildInformation') && Cv->GetBuildInformation;
	is(scalar Cv->hasModule('core'), 1);
	is(scalar Cv->hasModule('Core'), 0);
	diag("OpenCV modules: ", join(", ", Cv->hasModule));

	$line = __LINE__ + 1;
	eval { Cv->fontQt };
	err_is("no Qt");
}
