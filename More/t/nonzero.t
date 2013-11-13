# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 44;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::More', 0.31, qw(nonzero)) }

my $verbose = Cv->hasGUI();

if ($verbose) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC1);
	$arr->zero;
	$arr->set([map int rand $_ - 1, @{$arr->sizes}], [255]) for 1 .. 100;
	my $color = $arr->cvtColor(CV_GRAY2BGR);
	for (nonzero($arr)) {
		$color->circle($_, 4, [100, 200, 200], 2, CV_AA);
		$color->show;
		Cv->waitKey(30);
	}
	Cv->waitKey(1000);
}

if (1) {
	my $arr = Cv::Mat->new([100, 100], CV_8UC1);
	$arr->zero;
	$arr->m_set([], [[0], [1], [2], [3]]);
	my @nz1 = $arr->nonzero(1);
	my @nz0 = $arr->nonzero(0);
	my $nz = $arr->nonzero;
	is_deeply(\@nz1, [[1, 0], [2, 0], [3, 0]]);
	is_deeply(\@nz0, [[0, 1], [0, 2], [0, 3]]);
	is($nz, 3);
}

if (2) {
	for (CV_8UC1, CV_8SC1, CV_16SC1, CV_16UC1, CV_32SC1, CV_32FC1, CV_64FC1) {
		my $arr = Cv::Mat->new([100, 100], $_);
		$arr->zero;
		$arr->m_set([], [[0], [1], [2], [3]]);
		my @nz1 = nonzero($arr, 1);
		my @nz0 = nonzero($arr, 0);
		my $nz = nonzero($arr);
		is_deeply(\@nz1, [[1, 0], [2, 0], [3, 0]]);
		is_deeply(\@nz0, [[0, 1], [0, 2], [0, 3]]);
		is($nz, 3);
	}
}

if (3) {
	for my $arr (
		Cv::Mat->new([100, 100], CV_8UC1),
		Cv::MatND->new([100, 100], CV_8UC1),
		Cv::Image->new([100, 100], CV_8UC1),
		# Cv::SparseMat->new([100, 100], CV_8UC1),
		) {
		$arr->zero;
		$arr->m_set([], [[0], [1], [2], [3]]);
		my @nz1 = nonzero($arr, 1);
		my @nz0 = nonzero($arr, 0);
		my $nz = nonzero($arr);
		is_deeply(\@nz1, [[1, 0], [2, 0], [3, 0]], ref $arr);
		is_deeply(\@nz0, [[0, 1], [0, 2], [0, 3]], ref $arr);
		is($nz, 3);
	}
}

if (4.1) {
	my $arr = Cv::MatND->new([100], CV_8UC1);
	$arr->zero;
	$arr->m_set([], [[0], [1], [2], [3]]);
	my @nz1 = nonzero($arr, 1);
	my @nz0 = nonzero($arr, 0);
	my $nz = nonzero($arr);
	is_deeply(\@nz1, [[1], [2], [3]]);
	is_deeply(\@nz0, [[1], [2], [3]]);
	is($nz, 3);
}

if (4.3) {
	my $arr = Cv::MatND->new([100, 100, 100], CV_8UC1);
	$arr->zero;
	my @ix1 = ();
	my @ix0 = ();
	for (1..7) {
		push(@ix1, [map { $_ ? 1 : 0 } map { $_ & 4, $_ & 2, $_ & 1 } $_]);
		push(@ix0, [map { $_ ? 1 : 0 } map { $_ & 1, $_ & 2, $_ & 4 } $_]);
		$arr->set($ix1[-1], [1]);
	}
	my @nz1 = nonzero($arr, 1);
	my @nz0 = nonzero($arr, 0);
	my $nz = nonzero($arr);
	is_deeply(\@nz1, \@ix1);
	is_deeply(\@nz0, \@ix0);
	is($nz, 7);
}


SKIP: {
	skip "Test::Exception required", 3 unless eval "use Test::Exception";

	{
		my $arr = Cv::Mat->new([100, 100], CV_8UC2);
		throws_ok { my @nz = nonzero($arr) } qr/Unsupported format/;
	}

	{
		my $arr = Cv::MatND->new([10, 10, 10, 10], CV_8UC1);
		throws_ok { my @nz = nonzero($arr); } qr/Unsupported format/;
	}

	{
		my $arr = Cv::SparseMat->new([10, 10, 10, 10], CV_8UC1);
		throws_ok { my @nz = nonzero($arr); } qr/Bad argument/;
	}
}
