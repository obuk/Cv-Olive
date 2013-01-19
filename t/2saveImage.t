# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $verbose = Cv->hasGUI;

my $arr = Cv->loadImage($lena);
isa_ok($arr, 'Cv::Image');

if (1) {
	my $out = dirname($0) . "/tmp.jpg";
	rmdir($out);
	unlink($out);
	my $saved = $arr->SaveImage($out);
	unlink($out);
	ok($saved);
	isa_ok($saved, 'Cv::Image');
}

SKIP: {
	skip "return value if v1", 1 unless cvVersion() >= 2.000;
	my $out = dirname($0) . "/tmp.jpg";
	rmdir($out);
	unlink($out);
	mkdir $out, 0755;
	my $saved = $arr->SaveImage($out);
	rmdir($out);
	ok(!$saved);
}

if (10) {
	e { $arr->saveImage };
	err_is('Usage: Cv::Arr::cvSaveImage(image, filename, params=0)');
}

if (11) {
	e { $arr->saveImage('xxx') };
	err_like('OpenCV Error:');
}
