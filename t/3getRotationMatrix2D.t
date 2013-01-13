# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 10;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

# ============================================================
#  Cv->getRotationMatrix2D($center, $angle, $scale, $map);
# ============================================================

if (1) {
	my ($x, $y) = (0, 0);
	my $angle = 45;
	my $scale = 1;
	Cv->getRotationMatrix2D([$x, $y], $angle, $scale, my $map);
	isa_ok($map, "Cv::Mat");
	is($map->rows, 2);
	is($map->cols, 3);
	my $a = $map->getReal([0, 0]);
	my $b = $map->getReal([0, 1]);
	my $rad = CV_PI / 180;
	is_round_deeply('%g', $a, $scale * cos($angle * $rad));
	is_round_deeply('%g', $b, $scale * sin($angle * $rad));
}

if (2) {
	my ($x, $y) = (0, 0);
	my $angle = 45;
	my $scale = 1;
	my $map = Cv->getRotationMatrix2D([$x, $y], $angle, $scale);
	isa_ok($map, "Cv::Mat");
	is($map->rows, 2);
	is($map->cols, 3);
	my $a = $map->getReal([0, 0]);
	my $b = $map->getReal([0, 1]);
	my $rad = CV_PI / 180;
	is_round_deeply('%g', $a, $scale * cos($angle * $rad));
	is_round_deeply('%g', $b, $scale * sin($angle * $rad));
}

if (3) {
	my ($x, $y) = (0, 0);
	my $angle = 45;
	my $scale = 1;
	my $map = Cv->getRotationMatrix2D(
		[$x, $y], $angle, $scale, Cv::Mat->new([2, 3], CV_32FC1)
		);
	isa_ok($map, "Cv::Mat");
	is($map->rows, 2);
	is($map->cols, 3);
	my $a = $map->getReal([0, 0]);
	my $b = $map->getReal([0, 1]);
	my $rad = CV_PI / 180;
	is_round_deeply('%g', $a, $scale * cos($angle * $rad));
	is_round_deeply('%g', $b, $scale * sin($angle * $rad));
}

if (4) {
	my ($x, $y) = (0, 0);
	my $angle = 45;
	my $scale = 1;
	my $map = Cv::Mat->new([2, 3], CV_32FC1);
	Cv->getRotationMatrix2D([$x, $y], $angle, $scale, $map);
	my $a = $map->getReal([0, 0]);
	my $b = $map->getReal([0, 1]);
	my $rad = CV_PI / 180;
	is_round_deeply('%g', $a, $scale * cos($angle * $rad));
	is_round_deeply('%g', $b, $scale * sin($angle * $rad));
}

if (10) {
	e { Cv->GetRotationMatrix2D };
	err_is('Usage: Cv::cvGetRotationMatrix2D(center, angle, scale, mapMatrix)');
}

if (11) {
	e { Cv->cvGetRotationMatrix2D(1, 2, 3) };
	err_is('center is not of type CvPoint2D32f in Cv::cv2DRotationMatrix');
}
