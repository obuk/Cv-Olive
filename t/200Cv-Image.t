# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

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


if (3) {
	my $arr = Cv::Image->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::Image");
	my $arr2 = $arr->new;
}


if (4) {
	my $rows = 240;
	my $cols = 320;
	my $cn = 4;
	if (0) {
		my $step = $cols * $cn;
		my $data = chr(0) x ($rows * $step);
		my $mat = Cv::Image->new([ $rows, $cols ], eval("CV_8UC$cn"), $data);
		is(substr($data, 0 + $_, 1), chr(0)) for 0 .. $cn - 1;
		$mat->set([0, 0], [ map { 0x41 + $_ } 0 .. $cn - 1 ]);
		is(substr($data, 0 + $_, 1), chr(0x41 + $_)) for 0 .. $cn - 1;
		is($mat->get([0, 0])->[$_], 0x41 + $_) for 0 .. $cn - 1;
	} else {
		my $data = undef;
		my $mat = Cv::Image->new([ $rows, $cols ], eval("CV_8UC$cn"), $data);
	}
}


# ------------------------------------------------------------
# CvRect cvGetImageROI(const IplImage* image)
# void cvResetImageROI(IplImage* image)
# void cvSetImageROI(IplImage* image, CvRect rect)
# ------------------------------------------------------------

if (1) {
	my $image = Cv::Image->new([240, 320], CV_8UC3);
	ok($image);
	ok($image->isa("Cv::Image"));
	my $sz = $image->size;
	my $roi = [0, 0, @$sz];
	my $roi2 = $image->roi;
	is($roi2->[$_], $roi->[$_]) for 0 .. 3;
}

if (1) {
	my $image = Cv::Image->new([240, 320], CV_8UC3);
	isa_ok($image, 'Cv::Image');
	$image->SetImageROI(my $roi = [10, 20, 30, 40]);
	my $roi2 = $image->GetImageROI;
	is($roi2->[$_], $roi->[$_]) for 0 .. 3;
}

if (1) {
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

if (1) {
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
