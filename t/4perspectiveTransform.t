# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 65;
use Test::Exception;
BEGIN { use_ok('Cv') }

my @p1 = (
	[ 239.5, 184.7 ],
	[ 204.0, 134.8 ],
	[ 146.1, 162.5 ],
	[ 159.0, 174.1 ],
	[  76.8, 160.4 ],
	[ 236.1, 153.6 ],
	[ 164.3, 114.7 ],
	[ 229.2, 162.8 ],
	[ 217.8, 155.4 ],
	[ 131.6,  88.5 ],
);

my @p2 = (
	[ 221.8, 269.1 ],
	[ 207.0, 239.1 ],
	[ 173.0, 249.1 ],
	[ 179.1, 257.4 ],
	[ 186.6, 220.0 ],
	[ 223.4, 250.5 ],
	[ 187.1, 224.0 ],
	[ 218.2, 256.0 ],
	[ 213.0, 251.1 ],
	[ 176.0, 210.0 ],
);

my $H = Cv->findHomography(\@p1, \@p2, CV_RANSAC, 5);

my ($h, $w) = (240, 320);

my $corners_pts = [[0, 0], [$w, 0], [$w, $h], [0, $h]];
my $corners_mat = Cv::Mat->new([], CV_32FC2, $corners_pts);

if (1) {
	my $corners = $corners_mat->perspectiveTransform($corners_mat->new, $H);
	isa_ok($corners, 'Cv::Mat');
}

if (2) {
	my $corners = $corners_mat->perspectiveTransform($H);
	isa_ok($corners, 'Cv::Mat');
}

if (3) {
	my $corners = Cv->perspectiveTransform($corners_mat, $H);
	isa_ok($corners, 'Cv::Mat');
}

if (4) {
	my $corners = Cv->perspectiveTransform($corners_pts, $H);
	is(ref $corners, 'ARRAY');
}

if (5) {
	my @corners = Cv->perspectiveTransform($corners_pts, $H);
	is(ref $corners[0], 'ARRAY');
	is(scalar @corners, 1);
}

if (6) {
	my @corners = Cv->perspectiveTransform($corners_pts, $H);
	is(ref $corners[0], 'ARRAY');
	is(scalar @corners, 1);
}

if (7) {
	Cv::More->import(qw(cs));
	my @corners = Cv->perspectiveTransform($corners_pts, $H);
	is(ref $corners[0], 'ARRAY');
	is(scalar @corners, scalar @$corners_pts);
}
