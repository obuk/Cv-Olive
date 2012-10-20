# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 5;
use Scalar::Util qw(blessed);

BEGIN {
	use_ok('Cv');
	# use_ok('Cv::More');
}

sub xy {
	my @xy = map { ref $_ ? @$_ : $_ } @_;
	sprintf("(%g, %g)", map { int(($_ + 0.5e-7)*1e7)*1e-7 } @xy);
}

my $verbose = Cv->hasGUI;

my $img = Cv::Mat->new([300, 300], CV_8UC3);
my @points = ( [ 100, 100 ], [ 200, 100 ],
			   [ 100, 200 ], [ 200, 200 ] );


my ($center, $radius) = Cv->minEnclosingCircle(@points);
is(xy($center), xy([150, 150]));
ok(abs($radius - 50*sqrt(2)) < 3);
# print STDERR abs($radius - 50*sqrt(2)), "\n";

if ($verbose) {
	$img->zero;
	$img->circle($_, 3, cvScalar(0, 0, 255), CV_FILLED, CV_AA) for @points;
    $img->circle($center, cvRound($radius), cvScalar(0, 255, 255), 1, CV_AA); 
	$img->show("rect & circle");
	Cv->waitKey(1000);
}

my $center_radius = Cv->minEnclosingCircle([@points]);
is(xy($center_radius->[0]), xy([150, 150]));
ok(abs($center_radius->[1] - 50*sqrt(2)) < 3);
