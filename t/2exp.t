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
#  void cvExp(const CvArr* src, CvArr* dst)
# ------------------------------------------------------------

my $src = Cv::Mat->new([3], CV_32FC1);
$src->set([0], [rand 3]);
$src->set([1], [rand 3]);
$src->set([2], [rand 3]);

{
	my $dst = $src->exp;
	delta_ok($dst->getReal([0]), exp($src->getReal([0])));
	delta_ok($dst->getReal([1]), exp($src->getReal([1])));
	delta_ok($dst->getReal([2]), exp($src->getReal([2])));
}

{
	$src->exp(my $dst = $src->new);
	delta_ok($dst->getReal([0]), exp($src->getReal([0])));
	delta_ok($dst->getReal([1]), exp($src->getReal([1])));
	delta_ok($dst->getReal([2]), exp($src->getReal([2])));
}


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	throws_ok { $src->exp(0, 0) } qr/Usage: Cv::Arr::cvExp\(src, dst\) at $0/;

	throws_ok { $src->exp($src->new(CV_8UC1)) } qr/OpenCV Error:/;
}
