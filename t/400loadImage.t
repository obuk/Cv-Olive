# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $verbose = Cv->hasGUI;

{
	my $image = Cv->loadImage($lena);
	isa_ok($image, 'Cv::Image');
	if ($verbose) {
		$image->Show($lena);
		Cv->waitKey(1000);
	}
}

{
	my $image = Cv->loadImage($lena, CV_LOAD_IMAGE_GRAYSCALE);
	ok($image);
	if ($verbose) {
		$image->show($lena);
		Cv->waitKey(1000);
	}
}

{
	my $image = Cv::Image->load($lena);
	ok($image);
	isa_ok($image, 'Cv::Image');
	if ($verbose) {
		$image->show($lena);
		Cv->waitKey(1000);
	}
}

{
	my $image = Cv::Mat->load($lena, CV_LOAD_IMAGE_GRAYSCALE);
	ok($image);
	isa_ok($image, 'Cv::Mat');
	if ($verbose) {
		$image->show($lena);
		Cv->waitKey(1000);
	}
}

{
	my $image = Cv->loadImage("path-to-not-exist");
	ok(!$image);
}
