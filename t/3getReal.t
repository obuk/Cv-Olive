# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 33;
BEGIN {
	use_ok('Cv', -more);
}


our $line;

sub err_is {
	our $line;
	chop(my $a = $@);
	my $b = shift(@_) . " at $0 line $line";
	$b .= '.' if $a =~ m/\.$/;
	unshift(@_, "$a\n", "$b\n");
	goto &is;
}

# ------------------------------------------------------------
# double cvGetReal1D(const CvArr* arr, int idx0)
# double cvGetReal2D(const CvArr* arr, int idx0, int idx1)
# double cvGetReal3D(const CvArr* arr, int idx0, int idx1, int idx2)
# double cvGetRealND(const CvArr* arr, int* idx)
# ------------------------------------------------------------


if (1) {
	my $Xs = 'GetRealND';
	(my $xs = $Xs) =~ s/^[A-Z]+/\L$&/;

	my $src = Cv::MatND->new([ 320, 240, 2 ], CV_64FC1);

	no warnings 'redefine';
	no strict 'refs';

	my $idx0 = int rand $src->rows;
	my $idx1 = int rand $src->cols;

	my @got = ();
	local *{"Cv::core::cv$Xs"} = sub { @got = @_ };
	&{"Cv::core::cv$Xs"}($src, [$idx0, $idx1]);
	is(scalar @got, 2, "cv$Xs: scalar \@got");
	is($got[0], $src, "cv$Xs: src");
	is($got[1]->[0], $idx0, "cv$Xs: idx0");
	is($got[1]->[1], $idx1, "cv$Xs: idx1");

	local *{"Cv::Arr::cv$Xs"} = *{"Cv::core::cv$Xs"};
	# local *{"Cv::cv$Xs"} = *{"Cv::core::cv$Xs"};
	foreach my $fn ("GetReal", "getReal") {
		@got = ();
		$src->$fn($idx0, $idx1);
		is(scalar @got, 2, "cv$Xs: scalar \@got");
		is($got[0], $src, "cv$Xs: src");
		is(@{$got[1]}, $src->dims, "cv$Xs: src.dims");
		is($got[1]->[0], $idx0, "cv$Xs: idx0");
		is($got[1]->[1], $idx1, "cv$Xs: idx1");
		is($got[1]->[2], 0, "cv$Xs: idx1");

		@got = ();
		$src->$fn([$idx0, $idx1]);
		is(scalar @got, 2, "cv$Xs: scalar \@got");
		is($got[0], $src, "cv$Xs: src");
		is(@{$got[1]}, $src->dims, "cv$Xs: src.dims");
		is($got[1]->[0], $idx0, "cv$Xs: idx0");
		is($got[1]->[1], $idx1, "cv$Xs: idx1");
		is($got[1]->[2], 0, "cv$Xs: idx1");
	}
}

SKIP: {
	skip("need v2.0.0+", 2) unless cvVersion() >= 2.000000;
	Cv->setErrMode(1);
	my $can_hook = Cv->getErrMode() == 1;
	$can_hook = 0 if $^O eq 'cygwin';
	Cv->setErrMode(0);
	skip("can't hook cv:error", 4) unless $can_hook;
	for my $n (1..4) {
		my $m = Cv::Mat->new([240, 320], CV_64FC($n));
		my $v = cvScalar(map { rand 1 } 1..$n);
		my $i = [map { int rand $_ } @{$m->sizes}];
		eval { $m->set($i, $v) };
		if ($n == 1) {
			is($m->getReal($i), $v->[0]);
		} else {
			eval { $m->getReal($i) };
			like($@, qr/OpenCV Error:/i);
		}
	}
}
