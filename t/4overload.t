# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 171;

BEGIN {
	use_ok('Cv');
}

our $line;
sub err_is {
	our $line;
	chop(my $a = $@);
	my $b = "$_[0] at $0 line $line";
	$b .= '.' if $a =~ m/\.$/;
	# print STDERR "\n*** a = $a ***\n*** b = $b\n";
	unshift(@_, "$a\n", "$b\n");
	goto &is;
}

for my $type (CV_8UC3, CV_16SC4, CV_32SC2, CV_32FC2, CV_64FC1) {
	my $cn = CV_MAT_CN($type);

	my $stor = Cv::MemStorage->new(8192);
	ok($stor->isa('Cv::MemStorage'));

	my $seq = Cv::Seq::Point->new($type, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	my $n = 10;
	my @pts = (map { [ map { int rand 256 } 1 .. $cn ] } 1 .. $n);
	$seq->Push(@pts);
	
	my @pts2 = @$seq;
	for my $i (0 .. $n - 1) {
		for my $j (0 .. $cn - 1) {
			is($pts2[$i]->[$j], $pts[$i]->[$j]);
		}
	}

	my $mat2 = Cv::Mat->new([$n, 1], $type);
	for my $i (0 .. $n - 1) {
		$mat2->set($i, $pts[$i]);
	}

	if ($type eq CV_32SC2 || $type eq CV_32FC2) {
		my @pts3 = @$mat2;
		for my $i (0 .. $n - 1) {
			for my $j (0 .. $cn - 1) {
				is($pts3[$i]->[$j], $pts[$i]->[$j]);
			}
		}
	}
}

if (1) {
	my $mat1 = Cv::Mat->new([ 240, 320 ], CV_8UC1);
	my $mat2 = $mat1->new;
	ok($mat1 != $mat2);
	ok($mat1 ne $mat2);

	$line = __LINE__ + 1;
	eval { $mat1++ };
	err_is("$0: can't overload Cv::Mat::++");
}
