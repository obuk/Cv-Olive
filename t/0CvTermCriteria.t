# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 13;
BEGIN {	use_ok('Cv', qw(:nomore)) }

my ($type, $max_iter) = map { int rand 65536 } 1 .. 2;
my ($epsilon) = map { int rand 1 } 3;
my $term = cvTermCriteria($type, $max_iter, $epsilon);
is($term->[0], $type);
is($term->[1], $max_iter);
is($term->[2], $epsilon);

SKIP: {
	skip "no T", 9 unless Cv->can('CvTermCriteria');
	my $line;

	my $out = Cv::CvTermCriteria($term);
	is($out->[0], $term->[0]);
	is($out->[1], $term->[1]);
	is($out->[2], $term->[2]);

	$line = __LINE__ + 1;
	eval { Cv::CvTermCriteria() };
	is($@, "Usage: Cv::CvTermCriteria(term) at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvTermCriteria({}) };
	is($@, "Cv::CvTermCriteria: term is not of type CvTermCriteria at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvTermCriteria([]) };
	is($@, "Cv::CvTermCriteria: term is not of type CvTermCriteria at $0 line $line.\n");

	$line = __LINE__ + 1;
	eval { Cv::CvTermCriteria(['1x', 2, 3]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvTermCriteria([1, '2x', 3]) };
	is($@, "");

	$line = __LINE__ + 1;
	eval { Cv::CvTermCriteria([1, 2, '3x']) };
	is($@, "");

}
