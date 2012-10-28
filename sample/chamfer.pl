#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use warnings qw(Cv::More::fashion);
use File::Basename;

sub help {
	die <<"----";
This program demonstrates Chamfer matching -- computing a distance between an
edge template and a query edge image.
Usage: .\/chamfer <image edge map> <template edge map>,
By default the inputs are logo_in_clutter.png logo.png
----
}

my $imgname = shift || dirname($0) . "/logo_in_clutter.png";
my $tplname = shift || dirname($0) . "/logo.png";
my $img = Cv->loadImageM($imgname, CV_LOAD_IMAGE_GRAYSCALE);
my $tpl = Cv->loadImageM($tplname, CV_LOAD_IMAGE_GRAYSCALE);
&help unless $img && $tpl;
my $cimg = $img->cvtColor(CV_GRAY2BGR);

# if the image and the template are not edge maps but normal grayscale
# images, you might want to uncomment the lines below to produce the
# maps. You can also run Sobel instead of Canny.
# $img = $img->canny(5, 50, 3);
# $tpl = $tpl->canny(5, 50, 3);

my $best = Cv->chamerMatching($img, $tpl, my $results, my $costs);
die "matching not found\n" unless $best >= 0;

my ($w, $h) = ($cimg->width, $cimg->height);
my $green = [0, 255, 0];
foreach my $pt (@{$results->[$best]}) {
    my ($x, $y) = @{$pt};
    next unless 0 <= $x && $x < $w && 0 <= $y && $y < $h;
    $cimg->set($y, $x, $green);
}

$cimg->show("result");
Cv->waitKey;
