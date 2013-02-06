# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
use File::Basename;
use lib map { dirname($0) . "/$_" } qw(. ../tlib/arch ../tlib/lib); # XXXXX
use MY;
BEGIN { use_ok('Cv', -more) }

ok(CV_SIZEOF('CvSeq'));
ok(CV_SIZEOF('CvContour'));
ok(CV_SIZEOF('CvPoint'));
ok(CV_SIZEOF('CvPoint3D32f'));
ok(CV_SIZEOF('CvSeq'));
ok(CV_SIZEOF('CvSet'));
e { CV_SIZEOF('abc') };
err_is("CV_SIZEOF: abc unknwon");
