# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 4;
use File::Basename;
use lib dirname($0);
use MY;
use List::Util qw(sum min max);
BEGIN { use_ok('Cv') }

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
	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
}

$img->zero;

# Cv-0.16
Cv::More->import(qw(cs));

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
	my $box = [$points->fitEllipse];
	$_ *= 1.3 for @{$box->[1]};	# size * 1.2
	my @b4 = Cv->BoxPoints($box);
	$img->polyLine([\@b4], -1, &color, 1, CV_AA);
	$img->EllipseBox($box, &color, 1, CV_AA);
	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
}

sub color {
	[ map { (rand 128) + 127 } 1..3 ];
}


# Cv-0.19
e { my @list = Cv->FitEllipse };
err_is('Usage: Cv->FitEllipse2(points)');

my $pts3 = [[1, 2], [2, 3], [3, 4]];
my $pts5 = [[1, 2], [2, 3], [3, 4], [5, 6], [7, 8]];

e { my @list = Cv->FitEllipse($pts3) };
chomp($@);
$@ =~ /Number of points should be >= \d+/;
err_is("OpenCV Error: Incorrect size of input array ($&) in cvFitEllipse2");

Cv::More->unimport(qw(cs cs-warn));
Cv::More->import(qw(cs-warn));

{
	no warnings 'redefine';
	local *Carp::carp = \&Carp::croak;
	e { my @line = Cv->FitEllipse($pts5); };
	err_is("called in list context, but returning scaler");
}
