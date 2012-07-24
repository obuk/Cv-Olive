# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 13;
use Scalar::Util qw(blessed);

BEGIN {
	use_ok('Cv');
}

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $verbose = Cv->hasGUI;

if (1) {
	my $image = Cv->loadImage($lena, CV_LOAD_IMAGE_COLOR);
	isa_ok($image, 'Cv::Image');
	if ($verbose) {
		$image->show($lena);
		Cv->waitKey(1000);
	}
	my $gray = Cv::Image->new($image->sizes, CV_8UC1);
	my $gray2 = $image->cvtColor(CV_BGR2GRAY, $gray);
	is(blessed $image, 'Cv::Image');
	is(blessed $gray, 'Cv::Image');
	is(blessed $gray2, 'Cv::Image');
	if ($verbose) {
		$gray->show($lena);
		Cv->waitKey(1000);
	}
	my $gray3 = $image->cvtColor(CV_RGB2GRAY);
	my $rgb = $gray->cvtColor(CV_GRAY2RGB);
	my $bgr = $gray->cvtColor(CV_GRAY2BGR);
	my $hsv = $bgr->cvtColor(CV_BGR2HSV);
	my $hsv2 = $rgb->cvtColor(CV_BGR2HSV);
	my $yuv = $bgr->cvtColor(CV_BGR2YCrCb);
	my $yuv2 = $rgb->cvtColor(CV_RGB2YCrCb);
	my $bgr3 = $yuv->cvtColor(CV_YCrCb2BGR);
	my $rgb3 = $yuv->cvtColor(CV_YCrCb2RGB);
	for (1 .. 10) {
		my $row = int rand $bgr->rows;
		my $col = int rand $bgr->cols;
		my $p = $bgr->get($row, $col);
		my $q = $yuv->get($row, $col);
		my $r = $gray->get($row, $col);
		my $y = 0.299 * $p->[2] + 0.587 * $p->[1] + 0.114 * $p->[0];
		ok(abs($q->[0] - $y) < 1, "cvtColor(CV_BGR2CrCb) @ [$row, $col]");
		ok(abs($r->[0] - $y) < 1, "cvtColor(CV_BGR2GRAY) @ [$row, $col]");
	}
}

if (1) {
	my $image = Cv->loadImage($lena, CV_LOAD_IMAGE_COLOR);
	isa_ok($image, 'Cv::Image');
	my $gray = $image->cvtColor(
		$image->new($image->sizes, CV_8UC1), CV_BGR2GRAY,
		);
	if ($verbose) {
		$image->show($lena);
		Cv->waitKey(1000);
	}
}
