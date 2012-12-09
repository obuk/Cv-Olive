# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 12;
BEGIN {	use_ok('Cv', -more) }

my ($x, $y) = map { int rand 65536 } 0..1;
my $pt = cvPoint($x, $y);
is($pt->[0], $x);
is($pt->[1], $y);

SKIP: {
	skip "no T", 9 unless Cv->can('CvPoint');
	my $line;

	my $out = Cv::CvPoint($pt);
	is($out->[0], $pt->[0]);
	is($out->[1], $pt->[1]);

	$line = __LINE__ + 1;
	eval { Cv::CvPoint() };
	is($@, "Usage: Cv::CvPoint(pt) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint([]) };
	is($@, "Cv::CvPoint: pt is not of type CvPoint at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvPoint([1]) };
	is($@, "Cv::CvPoint: pt is not of type CvPoint at $0 line $line.\n");

	$line = __LINE__ + 1;
	my $pt2 = eval { Cv::CvPoint(['1x', '2y']) };
	is($@, "");
	is($pt2->[0], 1);
	is($pt2->[1], 2);

	eval "use Time::Piece";
	if ($@) {
		ok(1);
	} else {
		my $t1 = Time::Piece->strptime("2012-01-01", "%Y-%m-%d");
		my $t2 = Time::Piece->strptime("2012-01-02", "%Y-%m-%d");
		my $pt2 = Cv::CvPoint([$t2 - $t1, 0]);
		is($pt2->[0], $t2 - $t1);
		my $dt = $t2 - $t1;
		use Data::Dumper;
		print STDERR Data::Dumper->Dump([$dt], [qw($dt)]);
		print STDERR $t2 - $t1, "\n";
	}

}
