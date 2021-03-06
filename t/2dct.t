# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 3;
BEGIN { use_ok('Cv', -nomore) }

my $verbose = Cv->hasGUI;

# ------------------------------------------------------------
#  void cvDCT(const CvArr* src, CvArr* dst, int flags)
# ------------------------------------------------------------

my $src = Cv::Mat->new([100, 100], CV_64FC1);
for my $i (0 .. $src->rows - 1) {
	for my $j (0 .. $src->cols - 1) {
		my ($x, $y) = ($i / $src->rows, $j / $src->cols);
		$src->set([$i, $j], [sqrt($x * $x + $y * $y)]);
	}
}

{
	my $dct = $src->DCT(CV_DXT_INVERSE);
	if ($verbose) {
		$dct->show("dct");
		Cv->waitKey(1000);
	}
}

{
	my $dct = $src->DCT($src->new, CV_DXT_INVERSE);
	if ($verbose) {
		$dct->show("dct");
		Cv->waitKey(1000);
	}
}


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	{
		throws_ok { $src->DCT() } qr/Usage: Cv::Arr::cvDCT\(src, dst, flags\) at $0/;
	}

	{
		throws_ok { $src->DCT(\0, CV_DXT_FORWARD) } qr/OpenCV Error:/;
	}
}

