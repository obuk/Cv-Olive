# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 8;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

my $src = Cv->createImage([ 320, 240 ], 8, 3);
my $rng = Cv->RNG;
$rng->randArr($src, CV_RAND_NORMAL, cvScalarAll(0), cvScalarAll(255));

if (1) {
	my $dst2 = Cv::Arr::Copy($src, my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is_deeply($s, $d1);
	is_deeply($s, $d2);
}

if (2) {
	my $dst2 = $src->Copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is_deeply($s, $d1);
	is_deeply($s, $d2);
}

if (3) {
	my $dst2 = $src->copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is_deeply($s, $d1);
	is_deeply($s, $d2);
}

if (10) {
	e { $src->copy };
	err_is('Usage: Cv::Arr::cvCopy(src, dst, mask=NULL)');
}
