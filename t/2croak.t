# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN { use_ok('Cv::T') };
BEGIN { use_ok('Cv', qw(-more /^cv/)) }

e { cvCreateImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

# calling via autoload
e { Cv->createImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

# not calling via autoload
e { Cv->createImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

# calling via autoload
e { Cv->CreateImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

# not calling via autoload
e { Cv->CreateImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

e { my $scalar = Cv->createMat() };
err_is("Usage: Cv::cvCreateMat(rows, cols, type)");

TODO: {
	local $TODO = "fix error location in list context";
	e { my @list = Cv->createMatND() };
	err_is("Usage: Cv::cvCreateMatND(sizes, type)");
}
