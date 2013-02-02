# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 10;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN {	use_ok('Cv', -more) }

my ($type, $max_iter) = map { int rand 65536 } 1 .. 2;
my ($epsilon) = map { int rand 10 } 3;
my $term = cvTermCriteria($type, $max_iter, $epsilon);
is_deeply($term, [$type, $max_iter, $epsilon]);

SKIP: {
	skip "no T", 8 unless Cv->can('CvTermCriteria');

	{
		my $term2 = Cv::CvTermCriteria($term);
		is_deeply($term2, $term);
	}

	e { Cv::CvTermCriteria({}) };
	err_is("Cv::CvTermCriteria: term is not of type CvTermCriteria");

	e { Cv::CvTermCriteria([]) };
	err_is("Cv::CvTermCriteria: term is not of type CvTermCriteria");

	{
		use warnings FATAL => qw(all);
		e { Cv::CvTermCriteria(['1x', 2, 3]) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
		e { Cv::CvTermCriteria([1, '2x', 3]) };
		err_is("Argument \"2x\" isn't numeric in subroutine entry");
		e { Cv::CvTermCriteria([1, 2, '3x']) };
		err_is("Argument \"3x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $term2 = e { Cv::CvTermCriteria(['1x', '2x', '3x']) };
		err_is("");
		is_deeply($term2, [ 1, 2, 3 ]);
	}
}
