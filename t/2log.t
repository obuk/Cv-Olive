# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More;
BEGIN {
	eval "use Test::Number::Delta within => 1e-4";
	if ($@) {
		plan skip_all => "Test::Number::Delta";
	} else {
		plan tests => 9;
	}
}
BEGIN { use_ok('Cv', -nomore) }

# ------------------------------------------------------------
#  void cvLog(const CvArr* src, CvArr* dst)
# ------------------------------------------------------------

my $src = Cv::Mat->new([3], CV_32FC1);
$src->set([0], [rand 3]);
$src->set([1], [rand 3]);
$src->set([2], [rand 3]);

if (1) {
	my $dst = $src->log;
	delta_ok($dst->getReal(0), log($src->getReal(0)));
	delta_ok($dst->getReal(1), log($src->getReal(1)));
	delta_ok($dst->getReal(2), log($src->getReal(2)));
}

if (2) {
	$src->log(my $dst = $src->new);
	delta_ok($dst->getReal(0), log($src->getReal(0)));
	delta_ok($dst->getReal(1), log($src->getReal(1)));
	delta_ok($dst->getReal(2), log($src->getReal(2)));
}


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	throws_ok { $src->log(0, 0) } qr/Usage: Cv::Arr::cvLog\(src, dst\) at $0/;

	throws_ok { $src->log($src->new(CV_8UC1)) } qr/OpenCV Error:/;
}
