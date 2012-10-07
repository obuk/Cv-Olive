# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 313;

BEGIN {
	use_ok('Cv');
}

# structure member
if (1) {
	my $arr = Cv::Image->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::Image");
	my $type_name = Cv->TypeOf($arr)->type_name;
	is($type_name, 'opencv-image');

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
	is($arr->origin, 0);
	$arr->origin(1);
	is($arr->origin, 1);
	$arr->origin(0);
	is($arr->origin, 0);
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
		my $arr = new Cv::Image($_->{size}, $_->{type});
		isa_ok($arr, "Cv::Image");	
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
	my $arr = Cv::Image->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::Image");
	my $arr2 = $arr->new;
	isa_ok($arr2, ref $arr);
	my $arr3 = $arr->new(CV_8UC1);
	isa_ok($arr3, ref $arr);
}

# Cv::Image::Ghost
if (4) {
	no warnings;
	no strict 'refs';
	my $destroy = 0;
	my $destroy_ghost = 0;
	local *{Cv::Image::DESTROY} = sub { $destroy++; };
	local *{Cv::Image::Ghost::DESTROY} = sub { $destroy_ghost++; };
	my $mat = Cv::Image->new([ 240, 320 ], CV_8UC1);
	isa_ok($mat, 'Cv::Image');
	bless $mat, join('::', ref $mat, 'Ghost');
	$mat = undef;
	is($destroy, 0);
	is($destroy_ghost, 1);
}

# has data
if (5) {
}

# no depth
if (6) {
	eval { Cv::Image->new([240, 320], 7) };
	like($@, qr/usage:/);
}

# ------------------------------------------------------------
# CvRect cvGetImageROI(const IplImage* image)
# void cvResetImageROI(IplImage* image)
# void cvSetImageROI(IplImage* image, CvRect rect)
# ------------------------------------------------------------

if (10) {
	my $image = Cv::Image->new([240, 320], CV_8UC3);
	ok($image);
	ok($image->isa("Cv::Image"));
	my $sz = $image->size;
	my $roi = [0, 0, @$sz];
	my $roi2 = $image->roi;
	is($roi2->[$_], $roi->[$_]) for 0 .. 3;
}

if (11) {
	my $image = Cv::Image->new([240, 320], CV_8UC3);
	isa_ok($image, 'Cv::Image');
	$image->SetImageROI(my $roi = [10, 20, 30, 40]);
	my $roi2 = $image->GetImageROI;
	is($roi2->[$_], $roi->[$_]) for 0 .. 3;
}

if (12) {
	my $image = Cv::Image->new([240, 320], CV_8UC3);
	isa_ok($image, 'Cv::Image');
	$image->roi(my $roi = [10, 20, 30, 40]);
	my $roi2 = $image->roi;
	is($roi2->[$_], $roi->[$_]) for 0 .. 3;
	$image->ResetImageROI;
	my $roi4 = $image->roi;
	$roi = [0, 0, $image->width, $image->height];
	is($roi4->[$_], $roi->[$_]) for 0 .. 3;
}


# ------------------------------------------------------------
# int cvGetImageCOI(const IplImage* image)
# void cvSetImageCOI(IplImage* image, int coi)
# ------------------------------------------------------------

if (21) {
	my $arr = Cv::Image->new([3, 4], CV_8UC3);
	isa_ok($arr, 'Cv::Image');
	$arr->fill([1, 2, 3]);
	is($arr->coi, 0);

	foreach my $coi (1 .. 3) {
		$arr->coi($coi);
		foreach my $row (0 .. $arr->rows - 1) {
			foreach my $col (0 .. $arr->cols - 1) {
				is(${$arr->get([$row, $col])}[0], 1);
			}
		}
	}

	$arr->coi(0);
	foreach my $row (0 .. $arr->rows - 1) {
		foreach my $col (0 .. $arr->cols - 1) {
			is(${$arr->get([$row, $col])}[0], 1);
			is(${$arr->get([$row, $col])}[1], 2);
			is(${$arr->get([$row, $col])}[2], 3);
		}
	}
}

