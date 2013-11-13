# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN { use_ok('Cv', -nomore) }

my $src = Cv->createImage([ 320, 240 ], 8, 3);
my $rng = Cv->RNG;
$rng->randArr($src, CV_RAND_NORMAL, cvScalarAll(0), cvScalarAll(255));

{
	my $dst2 = Cv::Arr::Copy($src, my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is_deeply($s, $d1);
	is_deeply($s, $d2);
}

{
	my $dst2 = $src->Copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is_deeply($s, $d1);
	is_deeply($s, $d2);
}

{
	my $dst2 = $src->copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is_deeply($s, $d1);
	is_deeply($s, $d2);
}


SKIP: {
	skip "Test::Exception required", 2 unless eval "use Test::Exception";

	throws_ok { $src->copy } qr/Usage: Cv::Arr::cvCopy\(src, dst, mask=NULL\) at $0/;

	throws_ok { $src->copy($src->new(CV_8UC1)) } qr/OpenCV Error:/;
}
