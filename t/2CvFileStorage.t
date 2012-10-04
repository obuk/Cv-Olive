# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 22;

BEGIN {
	use_ok('Cv');
	# use_ok('Cv::More');
}

my $verbose = Cv->hasGUI;

my $yml = "objects.yml";
my $fs = Cv->OpenFileStorage($yml, CV_STORAGE_WRITE);

if (1) {
	my $type_name = 'opencv-image';
	my $obj = Cv::Image->new([3, 3], CV_32FC2);
	my $info = Cv->TypeOf($obj);
	is(ref $info, 'Cv::TypeInfo');
	is($info->type_name, $type_name);
	is(ref Cv->findType($type_name), 'Cv::TypeInfo');
	is(Cv->findType($type_name)->type_name, $type_name);
	foreach my $x (0 .. $obj->width - 1) {
		foreach my $y (0 .. $obj->height - 1) {
			$obj->set([$y, $x], [$y, $x]);
		}
	}
	$fs->write($type_name, $obj);
}

if (2) {
	my $type_name = 'opencv-matrix';
	my $obj = Cv::Mat->new([3, 3], CV_32FC2);
	my $info = Cv->TypeOf($obj);
	is(ref $info, 'Cv::TypeInfo');
	is($info->type_name, $type_name);
	is(ref Cv->findType($type_name), 'Cv::TypeInfo');
	is(Cv->findType($type_name)->type_name, $type_name);
	$obj->setIdentity;
	$fs->write($type_name, $obj);
}

if (3) {
	my $type_name = 'opencv-nd-matrix';
	my $obj = Cv::MatND->new([3, 3], CV_32FC2);
	my $info = Cv->TypeOf($obj);
	is(ref $info, 'Cv::TypeInfo');
	is($info->type_name, $type_name);
	is(ref Cv->findType($type_name), 'Cv::TypeInfo');
	is(Cv->findType($type_name)->type_name, $type_name);
	# $obj->setIdentity;
	$fs->write($type_name, $obj);
}

if (4) {
	my $type_name = 'opencv-sparse-matrix';
	my $obj = Cv::SparseMat->new([3, 3], CV_32FC2);
	my $info = Cv->TypeOf($obj);
	is(ref $info, 'Cv::TypeInfo');
	is($info->type_name, $type_name);
	is(ref Cv->findType($type_name), 'Cv::TypeInfo');
	is(Cv->findType($type_name)->type_name, $type_name);
	# $obj->setIdentity;
	$fs->write($type_name, $obj);
}

if (1) {
	# use Cv::More;
	my $type_name = 'opencv-sequence-tree';
	my $obj = Cv::Seq->new(CV_32SC2);
	my $info = Cv->TypeOf($obj);
	is(ref $info, 'Cv::TypeInfo');
	is($info->type_name, $type_name);
	is(ref Cv->findType($type_name), 'Cv::TypeInfo');
	is(Cv->findType($type_name)->type_name, $type_name);
	$obj->Push(pack("i2", $_ * 10 + 1, $_ * 10 + 2)) for 1 .. 10;
	$fs->write($type_name, $obj);
}

if (7) {
	use File::Basename;
	my $lena = dirname($0) . "/lena.jpg";
	my $image = Cv->loadImage($lena);
	$fs->write("lena", $image);
}

undef $fs;
$fs = Cv::FileStorage->new($yml, CV_STORAGE_READ);

if (8) {
	my $image = $fs->ReadByName(\0, "lena");
	is(ref $image, 'Cv::Image');
	if ($verbose) {
		$image->show;
		Cv->waitKey(1000);
	}
}

unlink($yml);
