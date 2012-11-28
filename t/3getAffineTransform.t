# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv', qw(:nomore));
}

sub is_gg {
	my ($a, $b) = splice(@_, 0, 2);
	unshift(@_, map { sprintf("%g", sprintf("%.7f", $_)) } $a, $b);
	goto &is;
}

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
	# print_map($map);
	is_gg($map->getReal([0, 0]), -1);
	is_gg($map->getReal([0, 1]), 0);
	is_gg($map->getReal([0, 2]), 320);
	is_gg($map->getReal([1, 0]), 0);
	is_gg($map->getReal([1, 1]), -1);
	is_gg($map->getReal([1, 2]), 240);

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

