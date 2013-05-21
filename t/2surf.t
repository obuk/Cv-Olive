# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 12;
BEGIN { use_ok('Cv') }

my $verbose = Cv->hasGUI;

if (1) {
	my $img = Cv::Image->new([300, 300], CV_8UC3);
	my @pt = ([100, 100], [100, 200], [200, 200], [200, 100]);
	$img->polyLine([\@pt], -1, [ 100, 255, 255], 1, CV_AA);
	my $storage = Cv->createMemStorage();
	my $params = cvSURFParams(my $hessianThreshold = 500, my $extended = 1);
	is($extended, $params->[0], 'extended');
	is($hessianThreshold, $params->[1], 'hessianThreshold');
	$img->extractSURF(\0, my $keypoints, my $descriptors, $storage, $params);
	for (map {
		+{
			pt        => $_->[0],
			laplacian => $_->[1],
			size      => $_->[2],
			dir       => $_->[3],
			hessian   => $_->[4],
		}
		 } @$keypoints) {
		# use Data::Dumper;
		# print STDERR Data::Dumper->Dump([$_], [qw(*_)]);
		$img->circle($_->{pt}, $_->{size}, [100, 255, 100], 1, CV_AA);
		my $ok = 0;
		for my $pt (@pt) {
			my ($x0, $y0) = @$pt;
			my ($x1, $y1) = @{$_->{pt}};
			my $e = sqrt(($x1 - $x0)**2 + ($y1 - $y0)**2);
			$ok++ if $_->{size} < $e;
		}
		ok($ok);
	}
	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
}