# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 2;
use List::Util qw(sum min max);

BEGIN {
	use_ok('Cv');
	# use_ok('Cv::More');
}

my $verbose = Cv->hasGUI;

my $img = Cv::Image->new([240, 320], CV_8UC3);
$img->origin(1);

if (1) {
	my @points;
	my $a = $img->height / $img->width;
	foreach (1 .. 100) {
		my $b = ((rand 0.2) - 0.10) * $img->height;
		my $x = ((rand 0.5) + 0.25) * $img->width;
		my $y = $a * $x + $b;
		push(@points, [$x, $y]);
	}
	$img->circle($_, 3, &color, 1, CV_AA) for @points; 
	my $box = Cv->fitEllipse(\@points);
	$_ *= 1.3 for @{$box->[1]};	# size * 1.2
	my @b4 = Cv->BoxPoints($box);
	$img->polyLine([\@b4], -1, &color, 1, CV_AA);
	$img->EllipseBox($box, &color, 1, CV_AA);
	my $seq = Cv::Seq::Point->new(CV_32FC2)->push(@b4);
	# my $ok = sum(map { $seq->pointPolygonTest($_, 0) } @points);
	# ok($ok > 0);
	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
}

$img->zero;

if (2) {
	my $points = Cv::Seq::Point->new(CV_32FC2);
	my $a = $img->height / $img->width;
	foreach (1 .. 100) {
		my $b = ((rand 0.2) - 0.10) * $img->height;
		my $x = ((rand 0.5) + 0.25) * $img->width;
		my $y = $a * $x + $b;
		$points->push([$x, $y]);
	}
	$img->circle($_, 3, &color, 1, CV_AA) for $points->toArray; 
	my $box = $points->fitEllipse;
	$_ *= 1.3 for @{$box->[1]};	# size * 1.2
	my @b4 = Cv->BoxPoints($box);
	$img->polyLine([\@b4], -1, &color, 1, CV_AA);
	$img->EllipseBox($box, &color, 1, CV_AA);
	my $seq = Cv::Seq::Point->new(CV_32FC2)->push(@b4);
	# my $ok = sum(map { $seq->pointPolygonTest($_, 0) } $points->toArray);
	# ok($ok > 0);
	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
}

sub color {
	[ map { (rand 128) + 127 } 1..3 ];
}


SKIP: {
	skip("need v2.0.0+", 1) unless cvVersion() >= 2.000000;
	skip("cygwin", 1) if $^O eq 'cygwin';
	Cv->setErrMode(1);
	my $can_hook = Cv->getErrMode() == 1;
	Cv->setErrMode(0);
	skip("can't hook cv:error", 1) unless $can_hook;
	eval { Cv->fitEllipse()	};
	# like($@, qr/usage/);
	ok($@);
}

