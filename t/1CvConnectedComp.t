# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 17;
BEGIN { use_ok('Cv::T') };
BEGIN {	use_ok('Cv', -more) }

my $area = int rand 16384;
my $value = [ map { (int rand 16384) + 0.5 } 0..3 ];
my $rect = [ map { int rand 16384 } 0..3 ];
my $contour = Cv::Seq->new(CV_8UC4);

if (1) {
	{
		my $cc = Cv::cvConnectedComp($area, $value, $rect, $contour);
		is($cc->[0], $area);
		is_deeply($cc->[1], $value);
		is_deeply($cc->[2], $rect);
		# is($cc->[3], $contour);

		my $cc2 = Cv::CvConnectedComp($cc);
		is($cc2->[0], $cc->[0]);
		is_deeply($cc2->[1], $cc->[1]);
		is_deeply($cc2->[2], $cc->[2]);
		# is($out->[3], $cc->[3]);
	}

	e { Cv::CvConnectedComp([]) };
	err_is("cc is not of type CvConnectedComp in Cv::CvConnectedComp");

	e { Cv::CvConnectedComp([$area, 'x', $rect, $contour]) };
	err_is("cc is not of type CvConnectedComp in Cv::CvConnectedComp");

	e { Cv::CvConnectedComp([$area, $value, 'x', $contour]) };
	err_is("cc is not of type CvConnectedComp in Cv::CvConnectedComp");

	e { Cv::CvConnectedComp([$area, $value, $rect, 'x']) };
	err_is("cc is not of type CvConnectedComp in Cv::CvConnectedComp");

	{
		use warnings FATAL => qw(all);
		my $cc = e { Cv::CvConnectedComp(['1x', $value, $rect, $contour]) };
		err_is("Argument \"1x\" isn't numeric in subroutine entry");
	}

	{
		no warnings 'numeric';
		my $cc = e { Cv::CvConnectedComp(['1x', $value, $rect, $contour]) };
		err_is("");
		is($cc->[0], 1);
		is_deeply($cc->[1], $value);
		is_deeply($cc->[2], $rect);
		# is($cc->[3], $contour);
	}
}
