# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;
BEGIN {
	use_ok('Cv', -more);
}

# void cvMorphologyEx(src, dst, temp, element, operation, iterations=1)

# ============================================================
#  (21) $src->MorphologyEx($element, CV_MOP_OPEN);
#  (22) $src->MorphologyEx($element, CV_MOP_TOPHAT);
#  (23) $src->MorphologyEx($dst, $tmp, $element, CV_MOP_BLACKHAT);
# ============================================================

if (21) {
	my $element = Cv->CreateStructuringElementEx(3, 3, 1, 1, CV_SHAPE_RECT);
	my $av;
	no strict 'refs';
	no warnings 'redefine';
	local *Cv::Arr::cvMorphologyEx = sub { $av = \@_; $_[0]; };
	my $src = Cv->CreateImage([ 320, 240 ], 8, 3);
	eval { $src->MorphologyEx($element, CV_MOP_OPEN); };
	is($av->[0], $src);
	is(ref $av->[1], ref $src);
	is($av->[2], undef);
	is($av->[3], $element);
	is($av->[4], CV_MOP_OPEN);
}

if (22) {
	my $element = Cv->CreateStructuringElementEx(3, 3, 1, 1, CV_SHAPE_RECT);
	my $av;
	no strict 'refs';
	no warnings 'redefine';
	local *Cv::Arr::cvMorphologyEx = sub { $av = \@_; $_[0]; };
	my $src = Cv->CreateImage([ 320, 240 ], 8, 3);
	eval { $src->MorphologyEx($element, CV_MOP_TOPHAT); };
	is($av->[0], $src);
	is(ref $av->[1], ref $src);
	is(ref $av->[2], ref $src);
	is($av->[3], $element);
	is($av->[4], CV_MOP_TOPHAT);
}

if (23) {
	my $element = Cv->CreateStructuringElementEx(3, 3, 1, 1, CV_SHAPE_RECT);
	my $av;
	no strict 'refs';
	no warnings 'redefine';
	local *Cv::Arr::cvMorphologyEx = sub { $av = \@_; $_[0]; };
	my $src = Cv->CreateImage([ 320, 240 ], 8, 3);
	my $dst = $src->new;
	my $tmp = $src->new;
	eval { $src->MorphologyEx($dst, $tmp, $element, CV_MOP_BLACKHAT); };
	is($av->[0], $src);
	is($av->[1], $dst);
	is($av->[2], $tmp);
	is($av->[3], $element);
	is($av->[4], CV_MOP_BLACKHAT);
}
