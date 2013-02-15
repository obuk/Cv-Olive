# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 11;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

my $verbose = Cv->hasGUI;

#  Cv->GetPerspectiveTransform($src, $dst, my $mapMatrix)

if (1) {
	my ($cx, $cy) = (160, 120);

	my @src = (
		[ $cx - 100, $cy - 100 ], [ $cx - 100, $cy + 100 ],
		[ $cx + 100, $cy + 100 ], [ $cx + 100, $cy - 100 ],
		);
	my @dst = (
		[ $cx - 100, $cy - 100 ], [ $cx - 100, $cy + 100 ],
		[ $cx + 100, $cy + 100 ], [ $cx + 100, $cy - 100 ],
		);

	if ($verbose) {
		my $img = Cv->createImage([2 * $cx, 2 * $cy], 8, 3);
		for (\@src, \@dst) {
			$img->zero;
			$img->polyLine([ $_ ], -1, [ 255, 255, 200 ], 1, CV_AA);
			$img->circle($_, 3, [ 200, 200, 255 ], -1) for @$_;
			$img->show;
			Cv->waitKey(200);
		}
	}

	Cv->GetPerspectiveTransform(\@src, \@dst, my $map);

	is_({ round => '%.7f' }, $map->getReal([0, 0]), 1);
	is_({ round => '%.7f' }, $map->getReal([0, 1]), 0);
	is_({ round => '%.7f' }, $map->getReal([0, 2]), 0);
	is_({ round => '%.7f' }, $map->getReal([1, 0]), 0);
	is_({ round => '%.7f' }, $map->getReal([1, 1]), 1);
	is_({ round => '%.7f' }, $map->getReal([1, 2]), 0);

	if ($verbose) {
		my $img = Cv::Mat->new([2 * $cy, 2 * $cx], CV_8UC3);
		for (\@src) {
			$img->zero;
			$img->polyLine([ $_ ], -1, [ 255, 255, 200 ], 1, CV_AA);
			$img->circle($_, 3, [ 200, 200, 255 ], -1) for @$_;
			$img->show;
			Cv->waitKey(200);
		}

		my $dst = $img->warpPerspective($map);
		$dst->show;
		Cv->waitKey(200);
			
		$img->show;
		Cv->waitKey(200);
			
		$dst->zero;
		$img->warpPerspective($dst, $map);
		$dst->show;
		Cv->waitKey(200);
	}

  SKIP: {
	  eval "use Cv::More;";
	  skip "can't load Cv::More", 1 if $@;
	  my $got = Cv->GetPerspectiveTransform(\@src, \@dst)->m_get([]);
	  is_deeply($got, $map->m_get([]));
	}
}

if (10) {
	e { Cv->GetPerspectiveTransform };
	err_is('Usage: Cv::cvGetPerspectiveTransform(src, dst, mapMatrix)');
}

if (11) {
	e { Cv->GetPerspectiveTransform(1, 2) };
	err_is('src is not of type CvPoint2D32f * in Cv::cvGetPerspectiveTransform');
}
