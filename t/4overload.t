# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 171;

BEGIN {
	use_ok('Cv');
}

for my $type (CV_8UC3, CV_16SC4, CV_32SC2, CV_32FC2, CV_64FC1) {
	my $cn = CV_MAT_CN($type);

	my $stor = Cv::MemStorage->new(8192);
	ok($stor->isa('Cv::MemStorage'));

	my $seq = Cv::Seq::Point->new($type, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	my $n = 10;
	my @pts = (map { [ map { int rand 256 } 1 .. $cn ] } 1 .. $n);
	$seq->Push(@pts);
	
	my @pts2 = @$seq;
	for my $i (0 .. $n - 1) {
		for my $j (0 .. $cn - 1) {
			is($pts2[$i]->[$j], $pts[$i]->[$j]);
		}
	}

	my $mat2 = Cv::Mat->new([$n, 1], $type);
	for my $i (0 .. $n - 1) {
		$mat2->set($i, $pts[$i]);
	}

	if ($type eq CV_32SC2 || $type eq CV_32FC2) {
		my @pts3 = @$mat2;
		for my $i (0 .. $n - 1) {
			for my $j (0 .. $cn - 1) {
				is($pts3[$i]->[$j], $pts[$i]->[$j]);
			}
		}
	}
}

