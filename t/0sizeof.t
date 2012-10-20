# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 8;
BEGIN {
	use_ok('Cv', qw(:nomore));
}

ok(CV_SIZEOF('CvSeq'));
ok(CV_SIZEOF('CvContour'));
ok(CV_SIZEOF('CvPoint'));
ok(CV_SIZEOF('CvPoint3D32f'));
ok(CV_SIZEOF('CvSeq'));
ok(CV_SIZEOF('CvSet'));
eval { CV_SIZEOF('abc') };
like($@, qr/abc: unknown/);
