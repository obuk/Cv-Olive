# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 24;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

is(CV_8U, 0);
is(CV_8S, 1);
is(CV_16U, 2);
is(CV_16S, 3);
is(CV_32S, 4);
is(CV_32F, 5);
is(CV_64F, 6);

is(CV_8UC(1), CV_8UC1);
is(CV_8SC(1), CV_8SC1);
is(CV_16UC(1), CV_16UC1);
is(CV_16SC(1), CV_16SC1);
is(CV_32SC(1), CV_32SC1);
is(CV_32FC(1), CV_32FC1);
is(CV_64FC(1), CV_64FC1);

is(CV_MAT_CN(CV_8UC1), 1);
is(CV_MAT_TYPE(CV_8UC2), CV_8UC2);

is(CV2IPL_DEPTH(CV_8UC1), IPL_DEPTH_8U);
is(IPL2CV_DEPTH(IPL_DEPTH_8U), CV_8U);
is(IPL2CV_DEPTH(IPL_DEPTH_8S), CV_8S);

is(CV_MAKETYPE(CV_8U, 1), CV_8UC1);
is(CV_MAKE_TYPE(CV_8U, 1), CV_8UC1);
eval { CV_MAKETYPE(CV_8U, 0) };
ok($@);
eval { CV_MAKETYPE(CV_8U, CV_CN_MAX + 1) };
ok($@);
