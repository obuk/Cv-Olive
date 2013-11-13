# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
BEGIN { use_ok('Cv', qw(-nomore)) }

SKIP: {
	skip "Test::Exception required", 7 unless eval "use Test::Exception";

	throws_ok { cvCreateImage() } qr/Usage: Cv::cvCreateImage\(size, depth, channels\) at $0/;

	# calling via autoload
	throws_ok { Cv->createImage() } qr/Usage: Cv::cvCreateImage\(size, depth, channels\) at $0/;

	# not calling via autoload
	throws_ok { Cv->createImage() } qr/Usage: Cv::cvCreateImage\(size, depth, channels\) at $0/;

	# calling via autoload
	throws_ok { Cv->CreateImage() } qr/Usage: Cv::cvCreateImage\(size, depth, channels\) at $0/;

	# not calling via autoload
	throws_ok { Cv->CreateImage() } qr/Usage: Cv::cvCreateImage\(size, depth, channels\) at $0/;

	throws_ok { my $scalar = Cv->createMat() } qr/Usage: Cv::cvCreateMat\(rows, cols, type\) at $0/;

  TODO: {
	  local $TODO = "fix error location in list context";
	  throws_ok { my @list = Cv->createMatND() } qr/Usage: Cv::cvCreateMatND\(sizes, type\) at $0/;
	}
}
