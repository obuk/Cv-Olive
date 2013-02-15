# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv', -more) }

my $verbose = Cv->hasGUI;

# ============================================================
#  Cv->GetAffineTransform($src, $dst, my $mapMatrix)
# ============================================================

if (1) {
	my ($cx, $cy) = (160, 120);

	my @src = (
		[ $cx - 100, $cy - 100 ], [ $cx, $cy ], [ $cx - 100, $cy + 100 ],
		);
	my @dst = (
		[ $cx + 100, $cy + 100 ], [ $cx, $cy ], [ $cx + 100, $cy - 100 ],
		);

	if ($verbose) {
		my $img = Cv->createImage([2 * $cx, 2 * $cy], 8, 3);
		for (\@src, \@dst) {
			$img->zero;
			$img->polyLine([ $_ ], -1, [ 255, 255, 200 ], 1, CV_AA);
			$img->circle($_, 3, [ 200, 200, 255 ], -1) for @$_;
			$img->show;
			Cv->waitKey(1000);
		}
	}

	Cv->GetAffineTransform(\@src, \@dst, my $map);

	is_({ round => '%.7f' }, $map->getReal([0, 0]), -1);
	is_({ round => '%.7f' }, $map->getReal([0, 1]), 0);
	is_({ round => '%.7f' }, $map->getReal([0, 2]), 320);
	is_({ round => '%.7f' }, $map->getReal([1, 0]), 0);
	is_({ round => '%.7f' }, $map->getReal([1, 1]), -1);
	is_({ round => '%.7f' }, $map->getReal([1, 2]), 240);

	if ($verbose) {
		my $img = Cv::Mat->new([2 * $cy, 2 * $cx], CV_8UC3);
		for (\@src) {
			$img->zero;
			$img->polyLine([ $_ ], -1, [ 255, 255, 200 ], 1, CV_AA);
			$img->circle($_, 3, [ 200, 200, 255 ], -1) for @$_;
			$img->show;
			Cv->waitKey(1000);
		}

		my $dst = $img->warpAffine($map);
		$dst->show;
		Cv->waitKey(1000);

		$img->show;
		Cv->waitKey(1000);

		$dst->zero;
		$img->warpAffine($dst, $map);
		$dst->show;
		Cv->waitKey(1000);
	}

  SKIP: {
	  eval "use Cv::More;";
	  skip "can't load Cv::More", 1 if $@;
	  my $got = Cv->GetAffineTransform(\@src, \@dst)->m_get([]);
	  is_deeply($got, $map->m_get([]));
	}
}

if (10) {
	e { Cv->GetAffineTransform };
	err_is('Usage: Cv::cvGetAffineTransform(src, dst, mapMatrix)');
}

if (11) {
	e { Cv->GetAffineTransform(1, 2) };
	err_is('src is not of type CvPoint2D32f * in Cv::cvGetAffineTransform');
}
