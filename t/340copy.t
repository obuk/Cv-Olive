# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

my $src = Cv->createImage([ 320, 240 ], 8, 3);
my $rng = Cv->RNG;
$rng->randArr($src, CV_RAND_NORMAL, cvScalarAll(0), cvScalarAll(255));
my @channels = (0 .. $src->channels - 1);

if (0) {
	my $dst2 = Cv::cvCopy($src, my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is($s->[$_], $d1->[$_]) for @channels;
	is($s->[$_], $d2->[$_]) for @channels;
}

if (2) {
	my $dst2 = $src->Copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is($s->[$_], $d1->[$_]) for @channels;
	is($s->[$_], $d2->[$_]) for @channels;
}

if (3) {
	my $dst2 = $src->copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is($s->[$_], $d1->[$_]) for @channels;
	is($s->[$_], $d2->[$_]) for @channels;
}
