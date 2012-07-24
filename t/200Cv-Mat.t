# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

if (1) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::Mat");
	my $type_name = Cv->TypeOf($arr)->type_name;
	is($type_name, 'opencv-matrix');

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
	for (map { +{ size => [240, 320], type => $_ } } @types) {
		my $arr = new Cv::Mat($_->{size}, $_->{type});
		isa_ok($arr, "Cv::Mat");	
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
	my $mat = Cv::Mat->new([ $rows, $cols ], eval("CV_8UC$cn"), $data);
	is(substr($data, 0 + $_, 1), chr(0)) for 0 .. $cn - 1;
	$mat->set([0, 0], [ map { 0x41 + $_ } 0 .. $cn - 1 ]);
	is(substr($data, 0 + $_, 1), chr(0x41 + $_)) for 0 .. $cn - 1;
	is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
}
