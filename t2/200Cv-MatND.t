# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

if (1) {
	my $arr = Cv::MatND->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::MatND");
	my $type_name = Cv->TypeOf($arr)->type_name;
	is($type_name, 'opencv-nd-matrix');

	is($arr->height, 240);
	is($arr->rows, 240);
	is($arr->width, 320);
	is($arr->cols, 320);
	is($arr->depth, 8);
	is($arr->channels, 3);
	is($arr->nChannels, 3);
	is($arr->dims, 2);
	my @sizes = $arr->getDims;
	is($sizes[0], 240);
	is($sizes[1], 320);
}


if (2) {
	my @types;
	foreach my $depth (CV_8U, CV_8S, CV_16S, CV_16U, CV_32S, CV_32F, CV_64F) {
		foreach my $ch (1..4) {
			push(@types, CV_MAKETYPE($depth, $ch));
		}
	}
	for ((map { +{ size => [240, 320], type => $_ } } @types),
		 { size => [2], type => CV_8UC1 },
		 { size => [2, 3], type => CV_8UC2 },
		 { size => [2, 3, 4], type => CV_8UC3 },
		 { size => [2, 3, 4, 5], type => CV_8UC4 },
		 { size => [2, 3, 4, 5, 6], type => CV_8SC1 },
		 { size => [2, 3, 4, 5, 6, 7], type => CV_8SC2 },
		 { size => [2, 3, 4, 5, 6, 7, 8], type => CV_8SC3 },
		 { size => [2, 3, 4, 5, 6, 7, 8, 9], type => CV_8SC4 },
		) {
		my $arr = new Cv::MatND($_->{size}, $_->{type});
		isa_ok($arr, "Cv::MatND");	
		is($arr->type, $_->{type});
		my $dims = $arr->getDims(\my @size);
		is($dims, scalar @{$_->{size}});
		for my $i (0 .. $dims - 1) {
			is($size[$i], $_->{size}[$i]);
		}
		is($arr->rows, $_->{size}[0]);
		is($arr->cols, $_->{size}[1]) if ($dims >= 2);
	}
}


if (3) {
	my $rows = 8;
	my $cols = 8;
	my $cn = 4;
	my $step = $cols * $cn;
	my $data = chr(0) x ($rows * $step);
	my $mat = Cv::MatND->new([ $rows, $cols ], eval("CV_8UC$cn"), $data);
	is(substr($data, 0 + $_, 1), chr(0)) for 0 .. $cn - 1;
	$mat->set([0, 0], [ map { 0x41 + $_ } 0 .. $cn - 1 ]);
	is(substr($data, 0 + $_, 1), chr(0x41 + $_)) for 0 .. $cn - 1;
	is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
}
