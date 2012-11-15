# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 7;

BEGIN {
	use_ok('Cv');
}

sub xy {
	my @xy = map { ref $_ ? @$_ : $_ } @_;
	sprintf("(%g, %g)", map { int(($_ + 0.5e-7)*1e7)*1e-7 } @xy);
}

my $verbose = Cv->hasGUI;

my $img = Cv::Mat->new([300, 300], CV_8UC3);
my @points = ( [ 100, 100 ], [ 200, 100 ],
			   [ 100, 200 ], [ 200, 200 ] );

if (1) {
	my $center_radius = Cv->minEnclosingCircle(@points);
	my ($center, $radius) = @$center_radius;
	is(xy($center), xy([150, 150]));
	ok(abs($radius - 50*sqrt(2)) < 3);
	# print STDERR abs($radius - 50*sqrt(2)), "\n";

	if ($verbose) {
		$img->zero;
		$img->circle($_, 3, cvScalar(0, 0, 255), CV_FILLED, CV_AA) for @points;
		$img->circle($center, $radius, cvScalar(0, 255, 255), 1, CV_AA); 
		$img->show("rect & circle");
		Cv->waitKey(1000);
	}
}

if (2) {
	my $center_radius = Cv->minEnclosingCircle([@points]);
	is(xy($center_radius->[0]), xy([150, 150]));
	ok(abs($center_radius->[1] - 50*sqrt(2)) < 3);
}


# Cv-0.16
if (10) {
	Cv->minEnclosingCircle(@points, my $center, my $radius);
	is(xy($center), xy([150, 150]));
	ok(abs($radius - 50*sqrt(2)) < 3);
}

if (11) {
	Cv->minEnclosingCircle(\@points, my $center, my $radius);
	is(xy($center), xy([150, 150]));
	ok(abs($radius - 50*sqrt(2)) < 3);
}


SKIP: {
	skip "can't use Capture::Tiny", 5 unless eval {
		require Capture::Tiny;
		sub capture (&;@) { goto &Capture::Tiny::capture };
	};

	my ($stdout, $stderr); my $line;
	Cv::More->unimport(qw(cs cs-warn));
	Cv::More->import(qw(cs-warn));
	($stdout, $stderr) = capture {
		my @line = Cv->minEnclosingCircle([[1, 2], [2, 3], [3, 4]]);
		is(scalar @line, 1);	# 1
	};
	is($stdout, '');			# 2
	like($stderr, qr/but .* scaler/); # 3

	Cv::More->unimport(qw(cs-warn));
	($stdout, $stderr) = capture {
		my @line = Cv->minEnclosingCircle([[1, 2], [2, 3], [3, 4]]);
	};
	is($stdout, '');			# 4
	is($stderr, '');			# 5
}
