# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 23;
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
	no warnings 'Cv::oldfashion';
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

# Cv-0.16

SKIP: {
	skip "can't use Capture::Tiny", 22 unless eval {
		require Capture::Tiny;
		sub capture (&;@) { goto &Capture::Tiny::capture };
	};

	my $pts3 = [[1, 2], [2, 3], [3, 4]];
	my $pts5 = [[1, 2], [2, 3], [3, 4], [5, 6], [7, 8]];

	my ($stdout, $stderr) = capture {
		use warnings 'Cv::oldfashion';
		my @list = Cv->FitEllipse($pts5);
		is(scalar @list, 1);	# 1
	};
	is($stdout, '');			# 2
	like($stderr, qr/but .* scaler/); # 3

	($stdout, $stderr) = capture {
		use warnings 'Cv::oldfashion';
		my $list = Cv->FitEllipse($pts5);
	};
	is($stdout, '');			# 4
	is($stderr, '');			# 5

	($stdout, $stderr) = capture {
		no warnings 'Cv::oldfashion';
		my @list = Cv->FitEllipse($pts5);
		is(scalar @list, 3);	# 6
	};
	is($stdout, '');			# 7
	is($stderr, '');			# 8

	($stdout, $stderr) = capture {
		no warnings 'Cv::oldfashion';
		my $list = Cv->FitEllipse($pts5);
	};
	is($stdout, '');			# 9
	is($stderr, '');			# 10

	my $points = Cv::Mat->new([ ], CV_32FC2, $pts5);

	($stdout, $stderr) = capture {
		use warnings 'Cv::oldfashion';
		my @list = $points->FitEllipse;
		is(scalar @list, 1);	# 11
	};
	is($stdout, '');			# 12
	like($stderr, qr/but .* scaler/); # 13

	($stdout, $stderr) = capture {
		use warnings 'Cv::oldfashion';
		my $list = $points->FitEllipse;
	};
	is($stdout, '');			# 14
	is($stderr, '');			# 15

	($stdout, $stderr) = capture {
		no warnings 'Cv::oldfashion';
		my @list = $points->FitEllipse;
		is(scalar @list, 3);	# 16
	};
	is($stdout, '');			# 17
	is($stderr, '');			# 18

	($stdout, $stderr) = capture {
		no warnings 'Cv::oldfashion';
		my $list = $points->FitEllipse;
	};
	is($stdout, '');			# 19
	is($stderr, '');			# 20

	my $line;
	use warnings 'Cv::oldfashion';
	eval {
		$line = __LINE__; my @list = Cv->FitEllipse($pts3);
	};
	like($@, qr/Incorrect size of input array/); # 21
	like($@, qr/line $line/);					 # 22
}
