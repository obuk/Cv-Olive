# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::More;

use 5.008008;
use strict;
use warnings;
use warnings::register qw(fashion);

our %M = (
	butscalar => "called in list context, but returning scaler",
	);

# use Cv qw( );
use Cv::Seq::Point;

package Cv;

sub m_croak {
	chomp(my ($e) = @_);
	1 while ($e =~ s/\s*(in|file|line|at) [^,]+,?\s*//g);
	unshift(@_, $e);
	goto &Carp::croak;
}


sub m_dims {
	if (@_) {
		if (ref $_[0]) {
			(scalar(@_), m_dims(@{$_[0]}));
		} else {
			(scalar(@_));
		}
	} else {
		();
	}
}


{
	no warnings 'redefine';
	sub Cv::Mat::new { goto &m_new }
}

sub m_new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	my $mat;
	if (@$sizes) {
		my ($rows, $cols) = @$sizes; $cols ||= 1;
		if (@_) {
			my ($data, $step) = @_; $step ||= &Cv::CV_AUTOSTEP;
			$mat = Cv::cvCreateMatHeader($rows, $cols, $type);
			$mat->setData($data, $step) if $data;
		} else {
			$mat = Cv::cvCreateMat($rows, $cols, $type);
		}
	} elsif (@_) {
		my @dims = m_dims(@_);
		return undef unless @dims;
		# push(@dims, 1) while @dims < 2;
		pop(@dims) if $dims[-1] == &Cv::CV_MAT_CN($type);
		my ($rows, $cols) = @dims; $cols ||= 1;
		$mat = Cv::cvCreateMat($rows, $cols, $type);
		eval { $mat->m_set([], \@_) };
		Cv::m_croak($@) if $@;
	}
	$mat;
}

package Cv::Arr;

{
	no warnings 'redefine';
	*Set = *set = sub {
		eval { &m_set(@_) };
		Cv::m_croak($@) if $@;
	}
}

sub m_set {
	my $mat = shift;
	my $value = pop;
	my $idx = ref $_[0] eq 'ARRAY'? shift : [ splice(@_, 0) ];
	my @dims = $mat->getDims;
	if (@dims <= @$idx) {
		$value = [ $value ] unless ref $value;
		unshift(@_, $mat, $idx, $value);
		goto &cvSetND;
	} elsif (ref $value && ref $value->[0] ||
			 ref $value && @$value > 1 && $dims[-1] > 1 &&
			 	Cv::CV_MAT_CN($mat->type) == 1) {
		$mat->m_set([@$idx, $_], $value->[$_]) for 0 .. $#{$value};
	} else {
		$mat->m_set([@$idx, 0], $value);
	}
	$mat;
}


{ *ToArray = \&CvtMatToArray }
sub CvtMatToArray {
	my $mat = shift; my @arr;
	if ($mat->cols == 1) {
		@arr = map { $mat->get([$_, 0]) } 0 .. $mat->rows - 1;
	}
	if ($mat->rows == 1) {
		@arr = map { $mat->get([0, $_]) } 0 .. $mat->cols - 1;
	}
	wantarray? @arr : \@arr;
}

package Cv::Seq::Point;

{ *ToArray = \&CvtSeqToArray }
sub CvtSeqToArray {
	# @array = cvtSeqToArray($seq)
	# @array = cvtSeqToArray($seq, $slice)
	# cvtSeqToArray($seq, \@array)
	# cvtSeqToArray($seq, \@array, $slice)
	my $self = CORE::shift;
	my $slice = ref $_[-1] eq 'ARRAY' && @{$_[-1]} == 2?
		CORE::pop : &Cv::CV_WHOLE_SEQ;
	$self->SUPER::CvtSeqToArray(my $string, $slice);
	if (@_ >= 1 && ref $_[0] eq 'ARRAY') {
		@{$_[0]} = ();
	} else {
		$_[0] = [];
	}
	$self->UnpackMulti($_[0], $string);
	wantarray? @{$_[0]} : $_[0];
}

package Cv::Arr;

use overload
	'@{}' => sub { $_[0]->ToArray },
	bool => sub { $_[0] },
	'<=>' => \&overload_cmp,
	cmp => \&overload_cmp,
	fallback => undef,
	nomethod => \&overload_nomethod;

sub overload_cmp {
	my ($l, $r) = @_;
	my ($lc, $rc) = (ref $l, ref $r);
	bless $l, 'overload::dummy';
	bless $r, 'overload::dummy';
	my $cmp = $l cmp $r;
	bless $l, $lc;
	bless $r, $rc;
	$cmp;
}

sub overload_nomethod {
	Carp::croak "$0: can't overload ", ref $_[0], "::", $_[3]
}

=xxx

sub matrix {
	my $matrix = shift;
	my $rows = @$matrix;
	my $cols = @{$matrix->[0]};
	my @m = map @$_, @$matrix;
	($rows, $cols, @m);
}

=cut

# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

package Cv;

sub GetBuildInformation {
	ref (my $class = shift) and Cv::croak 'class name needed';
	our $BuildInformation = '';
	if (Cv->version >= 2.004) {
		$BuildInformation ||= cvGetBuildInformation();
	}
	our %BuildInformation = ();
	unless (%BuildInformation) {
		for ($BuildInformation) {
			my $g = '';
			for (split(/\n/)) {
				s/^\s+//;
				s/\s+$//;
				if (s/([^\:]+):\s*//) {
					my $k = $1;
					if (/^$/) {
						$g = $k;
					} elsif ($g) {
						$BuildInformation{$g}{$k} = $_;
					} else {
						$BuildInformation{$k} = $_;
					}
				} else {
					$g = undef;
				}
			}
		}
	}
	wantarray? %BuildInformation : $BuildInformation;
}

sub HasModule {
	ref (my $class = shift) and Cv::croak 'class name needed';
	our %OpenCV_modules;
	unless (%OpenCV_modules) {
		my %x = Cv->GetBuildInformation();
		if (my $m = $x{q(OpenCV modules)}) {
			$OpenCV_modules{$_}++ for split(/\s+/, $m->{'To be built'});
			delete $OpenCV_modules{$_} for split(/\s+/, $m->{Disabled});
			delete $OpenCV_modules{$_} for split(/\s+/, $m->{Unavailable});
		}
	}
	grep { $OpenCV_modules{$_} } @_ ? @_ : keys %OpenCV_modules;
}

{
	no warnings 'redefine';
	sub cvHasQt {
		my $hasQt;
		if (Cv->can('cvFontQt')) {
			my %x = Cv->GetBuildInformation;
			while (my ($k, $v) = each %{$x{GUI}}) {
				$hasQt = $k if ($k =~ /^QT \d\.\w+$/i && $v =~ /^YES\.*/i)
			}
		}
		$hasQt;
	}
}

unless (Cv->hasQt) {
	*Cv::cvSetWindowProperty =
	*Cv::cvGetWindowProperty =
	*Cv::cvFontQt =
	*Cv::Arr::cvAddText =
	*Cv::cvDisplayOverlay =
	*Cv::cvDisplayStatusBar =
	*Cv::cvCreateOpenGLCallback = sub { Carp::croak "no Qt" };
}

# ============================================================
#  imgproc. Image Processing: Geometric Image Transformations
# ============================================================

package Cv::Arr;

sub Affine {
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	my $map = shift;
	eval {
		GetQuadrangleSubPix(
			$src, $dst, Cv::Mat->new([], &Cv::CV_32FC1, @$map));
	};
	Cv::m_croak($@) if $@;
	$src;
}


# ============================================================
#  imgproc. Image Processing: Structural Analysis and Shape Descriptors
# ============================================================

# ApproxChains (xs)
# ApproxPoly (xs)
# ArcLength (xs)
# BoundingRect (xs)
# BoxPoints (Cv)
# CalcPGH (xs)
# CalcEMD2 (TBD)
# CheckContourConvexity (xs)
# ConvexityDefect (xs)
# ContourArea (xs)
# ContourFromContourTree (xs)
# ConvexHull2 (xs)
# ConvexityDefects (xs)
# CreateContourTree (xs)
# EndFindContours (xs)
# FindContours (xs)
# FindNextContour (xs)
# FitEllipse2(Cv::More)
# FitLine (Cv::More)
# GetCentralMoment (xs)
# GetHuMoments (xs)
# GetNormalizedCentralMoment (xs)
# GetSpatialMoment (xs)
# MatchContourTrees (xs)
# MatchShapes (xs)
# MinAreaRect2 (Cv::More)
# MinEnclosingCircle (Cv::More)
# Moments (xs)
# PointPolygonTest (xs)
# PointSeqFromMat (xs)
# ReadChainPoint (xs)
# StartFindContours (xs)
# StartReadChainPoints (xs)
# SubstituteContour (xs)

package Cv::Arr;

sub BoundingRect {
	# CvRect cvBoundingRect(CvArr* points, int update=0)
	my $retval = eval { cvBoundingRect(@_) };
	Cv::m_croak($@) if $@;
	if (wantarray && warnings::enabled('Cv::More::fashion')) {
		Carp::carp $Cv::More::M{butscalar};
		return $retval;
	}
	wantarray? @$retval : $retval;
}

package Cv;

sub BoundingRect {
	# CvRect cvBoundingRect(CvArr* points, int update=0)
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	eval { @_ = (Cv::Mat->new([], &Cv::CV_32SC2, @_)) };
	Cv::m_croak($@) if $@;
	goto &Cv::Arr::BoundingRect;
}

package Cv::Arr;

{ *FitEllipse = \&FitEllipse2 }
sub FitEllipse2 {
	# FitEllipse2(IN points)
	my $retval = eval { cvFitEllipse2(@_) };
	Cv::m_croak($@) if $@;
	if (wantarray && warnings::enabled('Cv::More::fashion')) {
		Carp::carp $Cv::More::M{butscalar};
		return $retval;
	}
	wantarray? @$retval : $retval;
}

package Cv;

{ *FitEllipse = \&FitEllipse2 }
sub FitEllipse2 {
	# FitEllipse2(pt1, pt2, pt3, ...);
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	eval { @_ = (Cv::Mat->new([], &Cv::CV_32SC2, @_)) };
	Cv::m_croak($@) if $@;
	goto &Cv::Arr::FitEllipse2;
}

package Cv::Arr;

sub FitLine {
	# FitLine(IN points, IN dist_type, IN param, IN reps, IN aeps, OUT line)
	my $points = shift;
	my $rr = \ [ ];			# dummy
	if (@_ && (!defined $_[-1] || ref $_[-1] eq 'ARRAY')) {
		$rr = \ $_[-1]; pop;
	}
	my ($distType, $param, $reps, $aeps) = @_;
	$distType //= &Cv::CV_DIST_L2;
	$param    //= 0;
	$reps     //= 0.01;
	$aeps     //= 0.01;
	eval { cvFitLine($points, $distType, $param, $reps, $aeps, $$rr) };
	Cv::m_croak($@) if $@;
	my $retval = $$rr;
	if (wantarray && warnings::enabled('Cv::More::fashion')) {
		Carp::carp $Cv::More::M{butscalar};
		return $retval;
	}
	wantarray? @$retval : $retval;
}

package Cv;

sub FitLine {
	# cvFitLine(points, ...)
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $points = shift;
	my @dims = Cv::m_dims(@$points);
	eval { unshift(@_, Cv::Mat->new([], &Cv::CV_32FC($dims[-1]), @$points)) };
	Cv::m_croak($@) if $@;
	goto &Cv::Arr::FitLine;
}

package Cv::Arr;

{ *MinAreaRect = \&MinAreaRect2 }
sub MinAreaRect2 {
	# MinAreaRect2(IN points)
	my $points = shift;
	my $retval = eval { cvMinAreaRect2($points) };
	Cv::m_croak($@) if $@;
	if (wantarray && warnings::enabled('Cv::More::fashion')) {
		Carp::carp $Cv::More::M{butscalar};
		return $retval;
	}
	wantarray? @$retval : $retval;
}

package Cv;

{ *MinAreaRect = \&MinAreaRect2 }
sub MinAreaRect2 {
	# MinAreaRect2(pt1, pt2, pt3, ...);
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	eval { @_ = (Cv::Mat->new([], &Cv::CV_32SC2, @_)) };
	Cv::m_croak($@) if $@;
	goto &Cv::Arr::MinAreaRect2;
}

package Cv::Arr;

sub MinEnclosingCircle {
	# MinEnclosingCircle(IN points, OUT center OUT radius)
	my $points = shift;
	my ($xcenter, $xradius);	# dummy
	my ($rcenter, $rradius) = (\$xcenter, \$xradius);
	if (@_ >= 2 &&
		# undef or scalar
		(!defined $_[-2] || !ref $_[-2]) &&
		(!defined $_[-1] || !ref $_[-1])) {
		($rcenter, $rradius) = (\$_[-2], \$_[-1]);
		pop; pop;
	}
	my $retval = eval {
		cvMinEnclosingCircle($points, $$rcenter, $$rradius)?
			[$$rcenter, $$rradius] : undef;
	};
	Cv::m_croak($@) if $@;
	if (wantarray && warnings::enabled('Cv::More::fashion')) {
		Carp::carp $Cv::More::M{butscalar};
		return $retval;
	}
	wantarray? @$retval : $retval;
}

package Cv;

sub MinEnclosingCircle {
	# MinEnclosingCircle(points, ...)
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $n = @_;
	if (@_ >= 2 &&
		# undef or scalar
		(!defined $_[-2] || !ref $_[-2]) &&
		(!defined $_[-1] || !ref $_[-1])) {
		$n -= 2;
	}
	my @points = splice(@_, 0, $n);
	my @dims = Cv::m_dims(@points);
	eval { unshift(@_, Cv::Mat->new([], &Cv::CV_32SC2, @points)) };
	Cv::m_croak($@) if $@;
	goto &Cv::Arr::MinEnclosingCircle;
}


1;
