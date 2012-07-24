# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 13;
use Scalar::Util qw(blessed);

BEGIN {
	use_ok('Cv');
}

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
my @vtx = Sort(Cv->boxPoints(Cv->minAreaRect(@points)));
is(xy($vtx[$_]), xy($points[$_])) for 0 .. 3;
if ($verbose) {
	$img->zero;
	$img->circle($_, 3, cvScalar(0, 0, 255), CV_FILLED, CV_AA) for @points;
	$img->polyLine([ \@vtx ], 1, cvScalar(0, 255, 0), 1, CV_AA);
	$img->show("rect & circle");
	Cv->waitKey(1000);
}

my @vtx2 = Sort(Cv->boxPoints(Cv->minAreaRect(\@points, Cv::MemStorage->new)));
is(xy($vtx[$_]), xy($points[$_])) for 0 .. 3;
