# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 227;

BEGIN {
	use_ok('Cv');
}

# structure member
if (1) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::Mat");
	my $type_name = Cv->TypeOf($arr)->type_name;
	is($type_name, CV_TYPE_NAME_MAT);
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

# types
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

# inherit
if (3) {
	my $arr = Cv::Mat->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::Mat");
	my $arr2 = $arr->new;
	isa_ok($arr2, ref $arr);
	my $arr3 = $arr->new(CV_8UC1);
	isa_ok($arr3, ref $arr);
}

# Cv::Mat::Ghost
if (4) {
	no warnings;
	no strict 'refs';
	my $destroy = 0;
	my $destroy_ghost = 0;
	local *{Cv::Mat::DESTROY} = sub { $destroy++; };
	local *{Cv::Mat::Ghost::DESTROY} = sub { $destroy_ghost++; };
	my $mat = Cv::Mat->new([ 240, 320 ], CV_8UC1);
	isa_ok($mat, 'Cv::Mat');
	bless $mat, join('::', ref $mat, 'Ghost');
	$mat = undef;
	is($destroy, 0);
	is($destroy_ghost, 1);
}

# has data
if (5) {
	my $rows = 8;
	my $cols = 8;
	my $cn = 4;
	my $step = $cols * $cn;
	my $data = chr(0) x ($rows * $step);
	my $mat = Cv::Mat->new([ $rows, $cols ], CV_8UC($cn), $data);
	is(substr($data, 0 + $_, 1), chr(0)) for 0 .. $cn - 1;
	$mat->set([0, 0], [ map { 0x41 + $_ } 0 .. $cn - 1 ]);
	is(substr($data, 0 + $_, 1), chr(0x41 + $_)) for 0 .. $cn - 1;
	is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
}

# has data
if (5) {
	my $rows = 8;
	my $cols = 8;
	my $cn = 4;
	my $step = $cols * $cn;
	my $data = chr(0) x ($rows * $step);
	my $mat = Cv::Mat->new([ $rows, $cols ], CV_8UC($cn), $data);
	is(substr($data, 0 + $_, 1), chr(0)) for 0 .. $cn - 1;
	$mat->set([0, 0], [ map { 0x41 + $_ } 0 .. $cn - 1 ]);
	is(substr($data, 0 + $_, 1), chr(0x41 + $_)) for 0 .. $cn - 1;
	is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
}

# has data #2
if (6) {
	my $sizes = [8, 8];
	my $type = CV_8UC(4);
	my $step = $sizes->[1] * CV_MAT_CN($type);
	my @data = map { int rand 256 } 1 .. $sizes->[0] * $step;
	my $mat = Cv::Mat->new($sizes, $type, join('', map { chr $_ } @data));
	for my $i (0 .. $mat->rows - 1) {
		for my $j (0 .. $mat->cols - 1) {
			for my $k (0 .. CV_MAT_CN($mat->type) - 1) {
				is($mat->get([$i, $j])->[$k],
				   $data[($i * $mat->cols + $j) * CV_MAT_CN($mat->type) + $k]);
			}
		}
	}
}
