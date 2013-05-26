# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
BEGIN { use_ok('Cv') }

my $verbose = Cv->hasGUI;

if (1) {
	my $img = Cv::Image->new([300, 300], CV_8UC3);
	my @pt = ([100, 100], [100, 200], [200, 200], [200, 100]);
	$img->polyLine([\@pt], -1, [ 100, 255, 255], 1, CV_AA);
	my $storage = Cv->createMemStorage();
	my $params = cvSURFParams(my $hessianThreshold = 500, my $extended = 1);
	is($extended, $params->[0], 'extended');
	my $i = cvVersion() >= 2.003 ? 2 : 1;
	is($hessianThreshold, $params->[$i], 'hessianThreshold');
	my $gray = $img->cvtColor(CV_BGR2GRAY);
	$gray->extractSURF(\0, my $keypoints, my $descriptors, $storage, $params);
	my %got;
	for (map {
		+{
			pt        => $_->[0],
			laplacian => $_->[1],
			size      => $_->[2],
			dir       => $_->[3],
			hessian   => $_->[4],
		}
		 } @$keypoints) {
		$img->circle($_->{pt}, 2, [100, 255, 255], -1, CV_AA);
		$img->circle($_->{pt}, $_->{size}, [100, 255, 100], 1, CV_AA);
		for my $pt (@pt) {
			my ($x0, $y0) = @$pt;
			my ($x1, $y1) = @{$_->{pt}};
			my $e = sqrt(($x1 - $x0)**2 + ($y1 - $y0)**2);
			$got{@$pt}++ if $_->{size} < $e;
		}
	}
	ok($got{@$_}) for @pt;

	{
		my $n = $descriptors->elem_size / 4;
		package Cv::Seq::SURFDescriptor;
		our @ISA = qw(Cv::Seq::Point);
		sub template {
			my $self = CORE::shift;
			my ($t, $c) = ("f$n", $n);
			wantarray? ($t, $c) : $t;
		}
	}

	bless $descriptors, 'Cv::Seq::SURFDescriptor';
	is($descriptors->total, $keypoints->total, "descriptors");

	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
}
