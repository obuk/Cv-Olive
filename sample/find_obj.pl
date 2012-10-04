#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use Cv::More;
use File::Basename;

my $USE_FLANN = 1;

my ($object_filename, $scene_filename) =
	@ARGV == 2 ? @ARGV[0..1] :
	map { dirname($0) . "/" . $_ } ("box.png", "box_in_scene.png");

sub compareSURFDescriptors {
	my ($d1, $d2, $best, $length) = @_;
	my $total_cost = 0;
	die "$0: assertion failed \$length %4 == 0" unless $length % 4 == 0;
    for (my $i = 0; $i < $length; $i += 4) {
        my $t0 = $d1->[$i + 0] - $d2->[$i + 0];
        my $t1 = $d1->[$i + 1] - $d2->[$i + 1];
        my $t2 = $d1->[$i + 2] - $d2->[$i + 2];
        my $t3 = $d1->[$i + 3] - $d2->[$i + 3];
        $total_cost += $t0 * $t0 + $t1 * $t1 + $t2 * $t2 + $t3 * $t3;
        last if ($total_cost > $best);
    }
    # print STDERR "compareSURFDescriptors: $total_cost\n";
    return $total_cost;
}

sub naiveNearestNeighbor {
	my ($vec, $laplacian, $modelKeypoints, $modelDescriptors) = @_;

    # int length = (int)(model_descriptors->elem_size/sizeof(float));
	my $length = $modelDescriptors->elem_size / 4;

    $modelKeypoints->StartReadSeq(my $kreader);
    $modelDescriptors->StartReadSeq(my $reader);
	my ($neighbor, $dist1, $dist2) = (-1, 1e6, 1e6);
    foreach my $i (0 .. $modelDescriptors->total - 1) {
		my ($mx, $my, $mlaplacian, $msize, $mdir, $mhessian)
			= unpack("f2iiff", $kreader->ReadSeqElem);
		my $mvec = [unpack("f*", $reader->ReadSeqElem)];
		next unless ($mlaplacian == $laplacian);
		# print STDERR "naiveNearestNeighbor: $i\n";
        my $d = compareSURFDescriptors($vec, $mvec, $dist2, $length);
        if ($d < $dist1) {
            $dist2 = $dist1;
            $dist1 = $d;
            $neighbor = $i;
        } elsif ($d < $dist2) {
            $dist2 = $d;
		}
	}
	return $neighbor if ($dist1 < 0.6 * $dist2);
    return -1;
}

sub findPairs {
	my $objectKeypoints = shift;
	my $objectDescriptors = shift;
	my $imageKeypoints = shift;
	my $imageDescriptors = shift;
	my @ptpairs = ();
	if ($USE_FLANN) {
		die "can't call flannFindPairs\n" unless main->can('flannFindPairs');
		my $ptpairs = flannFindPairs(
			$objectKeypoints, $objectDescriptors,
			$imageKeypoints, $imageDescriptors,
			);
		@ptpairs = @$ptpairs;
	} else {
		$objectKeypoints->StartReadSeq(my $kreader);
		$objectDescriptors->StartReadSeq(my $reader);
		foreach my $i (0 .. $objectDescriptors->total - 1) {
			my ($x, $y, $laplacian, $size, $dir, $hessian)
				= unpack("f2iiff", $kreader->ReadSeqElem);
			my $vec = [unpack("f*", $reader->ReadSeqElem)];
			my $nearest_neighbor = naiveNearestNeighbor(
				$vec, $laplacian, $imageKeypoints, $imageDescriptors);
			if ($nearest_neighbor >= 0) {
				push(@ptpairs, $i, $nearest_neighbor);
			}
		}
	}
	wantarray ? @ptpairs : \@ptpairs;
}

# a rough implementation for object location
sub locatePlanarObject {
	my $objectKeypoints = shift;
	my $objectDescriptors = shift;
	my $imageKeypoints = shift;
	my $imageDescriptors = shift;
	my $src_corners = shift;
	my $dst_corners = shift;

	my $ptpairs = findPairs(
		$objectKeypoints, $objectDescriptors,
		$imageKeypoints, $imageDescriptors,
		);

    my $n = int((scalar @$ptpairs) / 2);
	return 0 if ($n < 4);

	my $pt1 = Cv::Mat->new([1, $n], CV_32FC2);
	my $pt2 = Cv::Mat->new([1, $n], CV_32FC2);

	bless $objectKeypoints, 'Cv::Seq::SURFPoint';
	bless $imageKeypoints, 'Cv::Seq::SURFPoint';

    foreach my $i (0 .. $n - 1) {
		my $k1pt = $objectKeypoints->get($ptpairs->[$i*2]);
		my $k2pt = $imageKeypoints->get($ptpairs->[$i*2 + 1]);
        $pt1->set([ 0, $i ], $k1pt->[0]);
        $pt2->set([ 0, $i ], $k2pt->[0]);
    }

	my $h = Cv::Mat->new([ 3, 3 ], CV_64F);
    Cv->FindHomography($pt1, $pt2, $h, CV_RANSAC, 5);

	my %H = ();
	foreach my $j (0 .. 2) {
		foreach my $i (0 .. 2) {
			$H{$j, $i} = $h->getReal([int $j, int $i]);
		}
	}

    for (my $i = 0; $i < 4; $i++) {
        my ($x, $y) = @{$src_corners->[$i]}[0..1];
        my $Z = 1.0 / ($H{2, 0}*$x + $H{2, 1}*$y + $H{2, 2});
        my $X = ($H{0, 0}*$x + $H{0, 1}*$y + $H{0, 2})*$Z;
		my $Y = ($H{1, 0}*$x + $H{1, 1}*$y + $H{1, 2})*$Z;
        $dst_corners->[$i] = cvPoint(cvRound($X), cvRound($Y));
    }
    return 1;
}


my $object = Cv->loadImage($object_filename, CV_LOAD_IMAGE_GRAYSCALE);
my $image = Cv->loadImage($scene_filename, CV_LOAD_IMAGE_GRAYSCALE);
unless ($object && $image) {
	fprintf STDERR "Can not load %s and/or %s\n" .
		"Usage: find_obj [<object_filename> <scene_filename>]\n",
		$object_filename, $scene_filename;
	exit(-1);
}

my $storage = Cv::MemStorage->new;
Cv->NamedWindow("Object", 1);
Cv->NamedWindow("Object Correspond", 1);

my @colors = (
	[   0,   0, 255 ],
	[   0, 128, 255 ],
	[   0, 255, 255 ],
	[   0, 255,   0 ],
	[ 255, 128,   0 ],
	[ 255, 255,   0 ],
	[ 255,   0,   0 ],
	[ 255,   0, 255 ],
	[ 255, 255, 255 ],
	);

my $object_color = $object->cvtColor(CV_GRAY2BGR);
# my ($imageKeypoints, $imageDescriptors) = (\0, \0);

my $i;
my $params = cvSURFParams(500, 1);

my $tt = Cv->getTickCount();
$object->ExtractSURF(
	\0, my $objectKeypoints, my $objectDescriptors,
	$storage, $params,
	);
bless $objectKeypoints, 'Cv::Seq::SURFPoint';
printf("Object Descriptors: %d\n", $objectDescriptors->total);
$image->ExtractSURF(
	\0, my $imageKeypoints, my $imageDescriptors,
	$storage, $params,
	);
bless $imageKeypoints, 'Cv::Seq::SURFPoint';
printf("Image Descriptors: %d\n", $imageDescriptors->total);
$tt = Cv->getTickCount() - $tt;
printf("Extraction time = %gms\n", $tt / (Cv->getTickFrequency() * 1000.0));

my @src_corners = (
	[ 0, 0 ],
	[ $object->width, 0 ],
	[ $object->width, $object->height ],
	[ 0, $object->height ]
	);
my @dst_corners;
my $correspond = Cv::Image->new(
	[$object->height + $image->height, $image->width], CV_8UC1,
	);

$correspond->ROI(
	cvRect(0, 0, $object->width, $object->height)
	);
$object->copy($correspond);
$correspond->ROI(
	cvRect(0, $object->height, $correspond->width, $correspond->height)
	);
$image->copy($correspond);
$correspond->resetROI;

if ($USE_FLANN) {
    print "Using approximate nearest neighbor search\n";
}

if (locatePlanarObject(
		$objectKeypoints, $objectDescriptors,
		$imageKeypoints, $imageDescriptors,
		\@src_corners, \@dst_corners)) {
	foreach my $i (0 .. 3) {
		my $r1 = $dst_corners[$i % 4];
		my $r2 = $dst_corners[($i + 1) % 4];
		$correspond->Line(
			[$r1->[0], $r1->[1] + $object->height],
			[$r2->[0], $r2->[1] + $object->height],
			$colors[8],
			3, CV_AA,
			);
	}
}

my $ptpairs = findPairs(
	$objectKeypoints, $objectDescriptors,
	$imageKeypoints, $imageDescriptors,
	);

for (my $i = 0; $i < @$ptpairs; $i += 2) {
	my $r1 = $objectKeypoints->get($ptpairs->[$i]);
	my $r2 = $imageKeypoints->get($ptpairs->[$i + 1]);
	$correspond->Line(
		$r1->[0], [ $r2->[0]->[0], $r2->[0]->[1] + $object->height ],
		$colors[8],
		);
}
$correspond->ShowImage("Object Correspond");

for (my $i = 0; $i < $objectKeypoints->total; $i++) {
	my $r = $objectKeypoints->get($i);
	my $center = $r->[0];
	my $radius = $r->[1] * 1.2 / 9 * 2;
	$object_color->Circle($center, $radius, $colors[0], 1, 8, 0);
}
$object_color->ShowImage("Object");

Cv->WaitKey;

BEGIN {
	die "$0: can't use Inline C.\n" if $^O eq 'cygwin';
}
use Cv::Config;
use Inline C => Config => %Cv::Config::C;
use Inline C => << '----';

#include <opencv/cv.h>
#ifndef __cplusplus
#define __OPENCV_BACKGROUND_SEGM_HPP__
#define __OPENCV_VIDEOSURVEILLANCE_H__
#endif
#include <opencv/cvaux.h>
#ifdef __cplusplus
#include <vector>
#endif
#include "typemap.h"

AV*
flannFindPairs(
	const CvSeq* objectKeypoints, const CvSeq* objectDescriptors,
	const CvSeq* imageKeypoints, const CvSeq* imageDescriptors)
{
#ifndef __cplusplus
	croak("can't call flannFindPairs");
#else
	AV* ptpairs = newAV();

	int length = (int)(objectDescriptors->elem_size/sizeof(float));
	cv::Mat m_object(objectDescriptors->total, length, CV_32F);
	cv::Mat m_image(imageDescriptors->total, length, CV_32F);

	// copy descriptors;
	CvSeqReader obj_reader;
	float* obj_ptr = m_object.ptr<float>(0);
	cvStartReadSeq(objectDescriptors, &obj_reader);
	for (int i = 0; i < objectDescriptors->total; i++) {
		const float* descriptor = (const float*)obj_reader.ptr;
		CV_NEXT_SEQ_ELEM(obj_reader.seq->elem_size, obj_reader);
		memcpy(obj_ptr, descriptor, length*sizeof(float));
		obj_ptr += length;
	}
	CvSeqReader img_reader;
	float* img_ptr = m_image.ptr<float>(0);
	cvStartReadSeq(imageDescriptors, &img_reader);
	for (int i = 0; i < imageDescriptors->total; i++) {
		const float* descriptor = (const float*)img_reader.ptr;
		CV_NEXT_SEQ_ELEM(img_reader.seq->elem_size, img_reader);
		memcpy(img_ptr, descriptor, length*sizeof(float));
		img_ptr += length;
	}

	// find nearest neighbors using FLANN
	cv::Mat m_indices(objectDescriptors->total, 2, CV_32S);
	cv::Mat m_dists(objectDescriptors->total, 2, CV_32F);
	cv::flann::Index flann_index(m_image, cv::flann::KDTreeIndexParams(4));  //using 4 randomized kdtrees
	flann_index.knnSearch(m_object, m_indices, m_dists, 2, cv::flann::SearchParams(64)); // maximum number of leafs checked

	int* indices_ptr = m_indices.ptr<int>(0);
	float* dists_ptr = m_dists.ptr<float>(0);
	for (int i=0;i<m_indices.rows;++i) {
		if (dists_ptr[2*i] < 0.6*dists_ptr[2*i+1]) {
			av_push(ptpairs, newSViv(i));
			av_push(ptpairs, newSViv(indices_ptr[2*i]));
		}
	}
	return ptpairs;
#endif
}

----
