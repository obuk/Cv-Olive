# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 11;
BEGIN { use_ok('Cv') }

my $verbose = Cv->hasGUI;

if (1) {
	my $img = Cv::Image->new([300, 300], CV_8UC3);
	my @pts = ([100, 100], [100, 200], [200, 200], [200, 100]);
	$img->polyLine([\@pts], -1, [ 100, 255, 255], 1, CV_AA);
	$img->circle($_, 3, [100, 255, 100], -1, CV_AA) for @pts;
	my $s = Cv->contourArea(\@pts);
	is($s, 10000);
	if ($verbose) {
		$img->show;
		Cv->waitKey(1000);
	}
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
		my @line = Cv->contourArea([[1, 2], [2, 3], [3, 4]]);
		is(scalar @line, 1);	# 1
	};
	is($stdout, '');			# 2
	like($stderr, qr/but .* scaler/); # 3

	Cv::More->unimport(qw(cs-warn));
	($stdout, $stderr) = capture {
		my @line = Cv->contourArea([[1, 2], [2, 3], [3, 4]]);
	};
	is($stdout, '');			# 4
	is($stderr, '');			# 5
}
