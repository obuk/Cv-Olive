# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 11;
BEGIN { use_ok('Cv') }

if (1) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	$points->FitLine(CV_DIST_L2, 0, 0.01, 0.01, my $line);
	my ($vx, $vy, $x0, $y0) = @$line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (2) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	$points->FitLine(CV_DIST_L2, 0, 0.01, 0.01, \my @line);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (3) {
	Cv->FitLine([[1, 2], [2, 3], [3, 4]], CV_DIST_L2, 0, 0.01, 0.01, \my @line);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
}

if (4) {
	Cv->FitLine([[1, 2, 1], [2, 3, 1.5], [3, 4, 2]], CV_DIST_L2, my $line);
	my ($vx, $vy, $vz, $x0, $y0, $z0) = @$line;
	cmp_ok(abs(1.0 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs(0.5 - ($vz / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
	cmp_ok(abs($z0 - ($vz / $vx) * $x0), '<', 1 + 1e-6);
}


# Cv-0.16
Cv::More->import(qw(cs));

if (11) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	my $line = $points->FitLine(CV_DIST_L2, 0, 0.01, 0.01);
	my ($vx, $vy, $x0, $y0) = @$line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (12) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	my @line = $points->FitLine(CV_DIST_L2, 0, 0.01, 0.01);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (13) {
	my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]], CV_DIST_L2, 0, 0.01, 0.01);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
}

if (14) {
	my $line = Cv->FitLine([[1, 2, 1], [2, 3, 1.5], [3, 4, 2]], CV_DIST_L2);
	my ($vx, $vy, $vz, $x0, $y0, $z0) = @$line;
	cmp_ok(abs(1.0 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs(0.5 - ($vz / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
	cmp_ok(abs($z0 - ($vz / $vx) * $x0), '<', 1 + 1e-6);
}

SKIP: {
	skip "can't use Capture::Tiny", 10 unless eval {
		require Capture::Tiny;
		sub capture (&;@) { goto &Capture::Tiny::capture };
	};

	my ($stdout, $stderr); my $line;
	Cv::More->unimport(qw(cs cs-warn));
	Cv::More->import(qw(cs-warn));
	($stdout, $stderr) = capture {
		my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]]);
		is(scalar @line, 1);	# 4
	};
	is($stdout, '');			# 5
	like($stderr, qr/but .* scaler/); # 6

	Cv::More->unimport(qw(cs-warn));
	($stdout, $stderr) = capture {
		my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]]);
	};
	is($stdout, '');			# 7
	is($stderr, '');			# 8

	($stdout, $stderr) = capture {
		eval {
			$line = __LINE__ + 1;
			my @line = Cv->FitLine;
		};
	};
	like($@, qr/line $line/);	# 9

	($stdout, $stderr) = capture {
		eval {
			my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]], -1);
		};
	};
	like($@, qr/OpenCV Error:/); # 10

}
