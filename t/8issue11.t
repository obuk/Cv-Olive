# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 7;
BEGIN { use_ok('Cv::T') }
BEGIN { use_ok('Cv') }

if (1) {
	my $seq = Cv::Seq::Point->new(CV_32SC1);
	ok($seq->isa('Cv::Seq::Point'));
	$seq->push(map [$_], 0 .. 9);

	if (1.1) {
		Cv::Arr::cvCvtSeqToArray($seq, my $elements);
		my @got = unpack("i*", $elements);
		my @expect = (0 .. 9);
		is_deeply(\@got, \@expect);
	}

	if (1.2) {
		Cv::Arr::cvCvtSeqToArray($seq, my $elements, [1, 3]);
		my @got = unpack("i*", $elements);
		my @expect = (1 .. 2);
		is_deeply(\@got, \@expect);
	}

	if (1.3) {
		Cv::Arr::cvCvtSeqToArray($seq, my $elements, [-1, 3]);
		my @got = unpack("i*", $elements);
		my @expect = (9, 0 .. 2);
		is_deeply(\@got, \@expect);
	}

	if (1.4) {
		Cv::Arr::cvCvtSeqToArray($seq, my $elements, [0, -1]);
		my @got = unpack("i*", $elements);
		my @expect = (0 .. 8);
		is_deeply(\@got, \@expect);
	}

}
