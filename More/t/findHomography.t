# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 65;
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

Cv->findHomography(
	Cv::Mat->new([], CV_32FC2, \@p1),
	Cv::Mat->new([], CV_32FC2, \@p2),
	my $H = Cv::Mat->new([3, 3], CV_64F),
	CV_RANSAC, 5);

if (11) {
	my $H2 = Cv->findHomography(
		Cv::Mat->new([], CV_32FC2, \@p1),
		Cv::Mat->new([], CV_32FC2, \@p2),
		Cv::Mat->new([3, 3], CV_64F),
		CV_RANSAC, 5);
	is_deeply([$H2->m_get([])], [$H->m_get([])]);
}

if (12) {
	Cv->findHomography(
		Cv::Mat->new([], CV_32FC2, \@p1),
		Cv::Mat->new([], CV_32FC2, \@p2),
		my $H2,
		CV_RANSAC, 5);
	is_deeply([$H2->m_get([])], [$H->m_get([])]);
}

if (13) {
	my $H2 = Cv->findHomography(
		Cv::Mat->new([], CV_32FC2, \@p1),
		Cv::Mat->new([], CV_32FC2, \@p2),
		CV_RANSAC, 5);
	is_deeply([$H2->m_get([])], [$H->m_get([])]);
}

if (21) {
	my $H2 = Cv->findHomography(
		\@p1, \@p2,
		Cv::Mat->new([3, 3], CV_64F),
		CV_RANSAC, 5);
	is_deeply([$H2->m_get([])], [$H->m_get([])]);
}

if (22) {
	Cv->findHomography(
		\@p1, \@p2,
		my $H2,
		CV_RANSAC, 5);
	is_deeply([$H2->m_get([])], [$H->m_get([])]);
}

if (23) {
	my $H2 = Cv->findHomography(\@p1, \@p2, CV_RANSAC, 5);
	is_deeply([$H2->m_get([])], [$H->m_get([])]);
}
