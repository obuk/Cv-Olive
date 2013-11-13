# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More;
BEGIN {
	eval "use Test::Number::Delta within => 1e-15";
	if ($@) {
		plan skip_all => "Test::Number::Delta";
	} else {
		plan tests => 10;
	}
}
BEGIN { use_ok('Cv', -nomore) }

my $verbose = Cv->hasGUI;

#  Cv->GetAffineTransform($src, $dst, my $mapMatrix)

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

	delta_ok($map->getReal([0, 0]), -1);
	delta_ok($map->getReal([0, 1]), 0);
	delta_ok($map->getReal([0, 2]), 320);
	delta_ok($map->getReal([1, 0]), 0);
	delta_ok($map->getReal([1, 1]), -1);
	delta_ok($map->getReal([1, 2]), 240);

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


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";
	throws_ok { Cv->GetAffineTransform } qr/Usage: Cv::cvGetAffineTransform\(src, dst, mapMatrix\) at $0/;
	throws_ok { Cv->GetAffineTransform(1, 2) } qr/src is not of type CvPoint2D32f \* in Cv::cvGetAffineTransform at $0/;
}
