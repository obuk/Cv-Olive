# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 22;
BEGIN { use_ok('Cv') }

sub xy {
	sprintf("(%d, %d)", map { ref $_ ? @$_ : $_ } @_);
}

sub Sort {
	my @pts = sort {
		$a->[1] <=> $b->[1] || $a->[0] <=> $b->[0]
	} map { [ int($_->[0] + 0.5), int($_->[1] + 0.5) ] } @_;
	@pts[0, 1, 3, 2];
}

my $verbose = Cv->hasGUI;

my $img = Cv::Mat->new([300, 300], CV_8UC3);
my @points = Sort([ 100, 100 ], [ 100, 200 ],
				  [ 200, 100 ], [ 200, 200 ]);

if (1) {
	my @vtx = Sort(Cv->boxPoints([Cv->minAreaRect(@points)]));
	is(xy($vtx[$_]), xy($points[$_])) for 0 .. 3;
	if ($verbose) {
		$img->zero;
		$img->circle($_, 3, cvScalar(0, 0, 255), CV_FILLED, CV_AA) for @points;
		$img->polyLine([ \@vtx ], 1, cvScalar(0, 255, 0), 1, CV_AA);
		$img->show("rect & circle");
		Cv->waitKey(1000);
	}
}

if (2) {
	my @vtx = Sort(Cv->boxPoints([Cv->minAreaRect(\@points)]));
	is(xy($vtx[$_]), xy($points[$_])) for 0 .. 3;
}

# Cv-0.16

SKIP: {
	skip "can't use Capture::Tiny", 10 unless eval {
		require Capture::Tiny;
		sub capture (&;@) { goto &Capture::Tiny::capture };
	};
	my ($stdout, $stderr) = capture(sub {
		use warnings 'Cv::More::fashion';
		my @list = Cv->minAreaRect(@points);
		is(scalar @list, 1);	# 1
	});
	is($stdout, '');			# 2
	like($stderr, qr/but .* scaler/); # 3

	($stdout, $stderr) = capture {
		use warnings 'Cv::More::fashion';
		my $list = Cv->minAreaRect(@points);

	};
	is($stdout, '');			# 4
	is($stderr, '');			# 5

	($stdout, $stderr) = capture {
		no warnings 'Cv::More::fashion';
		my @list = Cv->minAreaRect(@points);
		is(scalar @list, 3);	# 6
	};
	is($stdout, '');			# 7
	is($stderr, '');			# 8

	($stdout, $stderr) = capture {
		no warnings 'Cv::More::fashion';
		my $list = Cv->minAreaRect(@points);
	};
	is($stdout, '');			# 9
	is($stderr, '');			# 10
}

