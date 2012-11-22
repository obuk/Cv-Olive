# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

sub is_g {
	my ($a, $b) = splice(@_, 0, 2);
	unshift(@_, map { sprintf("%g", $_) } $a, $b);
	goto &is;
}

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
	is_g($a, $scale * cos($angle * $rad));
	is_g($b, $scale * sin($angle * $rad));
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
	is_g($a, $scale * cos($angle * $rad));
	is_g($b, $scale * sin($angle * $rad));
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
	is_g($a, $scale * cos($angle * $rad));
	is_g($b, $scale * sin($angle * $rad));
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
	is_g($a, $scale * cos($angle * $rad));
	is_g($b, $scale * sin($angle * $rad));
}

sub print_map {
	my $map = shift;
	for my $row (0 .. $map->rows - 1) {
		print STDERR "[ ";
		for my $col (0 .. $map->cols - 1) {
			print STDERR $map->getReal([$row, $col]), ", ";
		}
		print STDERR "]\n";
	}
}

