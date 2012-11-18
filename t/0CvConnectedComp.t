# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 26;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my $area = int rand 16384;
my $value = [ map { (int rand 16384) + 0.5 } 0..3 ];
my $rect = [ map { int rand 16384 } 0..3 ];
my $contour = Cv::Seq->new(CV_8UC4);

SKIP: {
	skip "no T", 25 unless Cv->can('CvConnectedComp');
	my $line;

	my $cc = Cv::cvConnectedComp($area, $value, $rect, $contour);
	is($cc->[0], $area);
	is($cc->[1]->[$_], $value->[$_]) for 0 .. 3;
	is($cc->[2]->[$_], $rect->[$_]) for 0 .. 3;
	# is($cc->[3], $contour);

	my $out = Cv::CvConnectedComp($cc);
	is($out->[0], $cc->[0]);
	is($out->[1]->[$_], $cc->[1]->[$_]) for 0 .. 3;
	is($out->[2]->[$_], $cc->[2]->[$_]) for 0 .. 3;
	# is($out->[3], $cc->[3]);

	$line = __LINE__ + 1;
	eval { Cv::CvConnectedComp() };
	is($@, "Usage: Cv::CvConnectedComp(cc) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvConnectedComp([]) };
	is($@, "Cv::CvConnectedComp: cc is not of type CvConnectedComp at $0 line $line.\n");

	$line = __LINE__ + 1;
	my $cc = eval { Cv::CvConnectedComp(['1x', $value, $rect, $contour]) };
	is($@, "");
	is($cc->[0], 1);

	$line = __LINE__ + 1;
	eval { Cv::CvConnectedComp([$area, 'x', $rect, $contour]) };
	is($@, "Cv::CvConnectedComp: cc is not of type CvConnectedComp at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvConnectedComp([$area, $value, 'x', $contour]) };
	is($@, "Cv::CvConnectedComp: cc is not of type CvConnectedComp at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvConnectedComp([$area, $value, $rect, 'x']) };
	is($@, "Cv::CvConnectedComp: cc is not of type CvConnectedComp at $0 line $line.\n");

}
