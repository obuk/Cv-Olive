# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 13;
use Scalar::Util qw(blessed);

BEGIN {
	use_ok('Cv');
}

if (1) {
	my $arr = Cv::Image->new([3, 4], CV_8UC3);
	isa_ok($arr, 'Cv::Image');
	$arr->fill([1, 2, 3]);
	my ($b, $g, $r) = $arr->Split;
	foreach my $row (0 .. $arr->rows - 1) {
		foreach my $col (0 .. $arr->cols - 1) {
			is(${$b->Get([$row, $col])}[0], 1);
			is(${$g->Get([$row, $col])}[0], 2);
			is(${$r->Get([$row, $col])}[0], 3);
		}
	}

}
