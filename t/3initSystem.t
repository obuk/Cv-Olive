# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 2;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

Cv->initSystem([ "-display", ":0.0" ]);

SKIP: {
	skip('version 2.4.0+', 1) unless Cv->hasGUI;
	use File::Basename;
	my $imagename = shift || dirname($0) . "/lena.jpg";
	my $img = Cv->loadImage($imagename);
	Cv->namedWindow('Cv', 0);
	$img->show;
	Cv->waitKey(1000);
}
