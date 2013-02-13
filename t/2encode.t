# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 237;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv', -nomore) }

my $verbose = Cv->hasGUI;

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $img = Cv->loadImage($lena);
isa_ok($img, 'Cv::Image');
my $font = Cv->InitFont(CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0, 1, CV_AA);
isa_ok($font, 'Cv::Font');
use Time::HiRes qw(gettimeofday);

SKIP: {
	skip('no cvEncodeImage', 233) unless Cv::Arr->can('cvEncodeImage');

	my $debug = 1;
	foreach my $q (0 .. 20) {
		my $params = [ eval "&CV_IMWRITE_JPEG_QUALITY", $q ];
		my $jpg = $img->encodeImage(".jpg", $params);
		# my $jpg = cvEncodeImage($img, ".jpg", $params);
		isa_ok($jpg, 'Cv::Mat');
		$img->saveImage(my $tmpjpg = "/var/tmp/$$.jpg", $params);
		my $jpg_str = `cat $tmpjpg`;
		# ok($jpg->ptr eq $jpg_str, "ptr $q");
		if ($debug > 1) {
			my $jpg_str = `cat $tmpjpg`;
			printf STDERR ("$q: a = %d, b = %d (%d x %d)\n",
						   length($jpg->ptr), length($jpg_str),
						   $jpg->rows, $jpg->cols);
		}
		my $dec = $jpg->decodeImage;
		my $dec2 = $jpg->decodeImageM;
		my $dec3 = Cv->decodeImage($jpg_str);
		my $dec4 = Cv->decodeImageM($jpg_str);
		isa_ok($dec, 'Cv::Image');
		my $sum1 = $dec->sum;
		my $sum2 = $dec2->sum;
		is($sum1->[$_], $sum2->[$_], "sum dec12 $_") for 0 ..3;
		my $sum3 = $dec3->sum;
		my $sum4 = $dec4->sum;
		is($sum3->[$_], $sum4->[$_], "sum dec34 $_") for 0 ..3;
		my $lod = Cv->loadImage($tmpjpg); unlink($tmpjpg);
		isa_ok($lod, 'Cv::Image');
		if ($verbose) {
			$dec->putText(sprintf("jpg: quality %d, size %d", $q, $jpg->total),
						  [ 30, 30 ], $font, cvScalarAll(255));
			$dec->show;
			my $c = Cv->waitKey(100);
			last if ($c >= 0 && ($c & 0x7f) == 27);
		}
	}

	e { Cv::Arr::cvEncodeImage() };
	err_is('Usage: Cv::Arr::cvEncodeImage(arr, ext, params)');

	e { $img->encodeImage(".xxx") };
	err_like('OpenCV Error:');
}
