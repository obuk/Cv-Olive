# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
BEGIN { use_ok('Cv') }

Cv::More->import(qw(cs));
is($Cv::More::O{cs}, 1);

Cv::More->unimport(qw(cs));
is($Cv::More::O{cs}, 0);

open STDERR, ">/dev/null";
eval { Cv::More->import(qw(xx)) };
ok(!defined $Cv::More::O{xx});

eval { Cv::More->unimport(qw(xx)) };
ok(!defined $Cv::More::O{xx});
