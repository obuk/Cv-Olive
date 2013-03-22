# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use utf8;

use Test::More;
BEGIN {
	plan skip_all => "Pango required"
        unless eval "use Pango; 1";
	plan qw(no_plan);
}

BEGIN {
	use_ok('Cv', -nomore);
	use_ok('Cv::Pango');
}

my $verbose = Cv->hasGUI;

my $bgra = Cv::Mat->new([240, 320], CV_8UC4);
if (41) {
	my ($text, $org, $font) = (
		"hello, world", [20, 50],
		Cv->InitFont(CV_FONT_HERSHEY_SIMPLEX, 1.0, 1.0, 0, 2, CV_AA),
		);
	$bgra->boxText($text, $org, $font, cvScalarAll(127));
	$bgra->putText($text, $org, $font, CV_RGB(255, 255, 100));
}

if (42) {
	my ($text, $org, $font) = (
		"hello, world", [20, 100],
		Pango::FontDescription->from_string('Sans Serif 22.5'),
		);
	$bgra->boxText($text, $org, $font, cvScalarAll(127));
	$bgra->putText($text, $org, $font, CV_RGB(255, 255, 100));
}

if (43) {
	my ($text, $org, $font) = (
		"\x{03A0}\x{03B1}\x{03BD}\x{8A9E}", # "Παν語",
		# 'こんにちは',
		[20, 200],
		'Sans Serif 42',
		);
	$bgra->boxText($text, $org, $font, cvScalarAll(127));
	$bgra->putText($text, $org, $font, cvScalarAll(255));
}

if ($verbose) {
	$bgra->show("Font");
	Cv->waitKey(1000);
}


my $bgr = Cv::Mat->new([240, 320], CV_8UC3);
if (33) {
	my ($text, $org, $font) = (
		"\x{03A0}\x{03B1}\x{03BD}\x{8A9E}", # "Παν語",
		# 'こんにちは',
		[20, 200],
		'Sans Serif 42',
		);
	$bgr->boxText($text, $org, $font, cvScalarAll(127));
	$bgr->putText($text, $org, $font, CV_RGB(255, 200, 200));
}

if ($verbose) {
	$bgr->show("Font");
	Cv->waitKey(1000);
}
