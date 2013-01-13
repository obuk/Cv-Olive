# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::More;

use 5.008008;
use strict;
use warnings;

# use Cv qw( );
use Cv::Seq;
use Cv::Seq::Point;
use Cv::Seq::Point2;
use Cv::Seq::Rect;
use Cv::Seq::SURFPoint;

package Cv;

our %O;

$O{$_} = 0 for qw(cs cs-warn);

our %M;

$M{butscalar} = "called in list context, but returning scaler";

package Cv::More;

sub import {
	my $self = shift;
	for (@_) {
		if (defined $Cv::O{$_}) {
			$O{$_} = 1;
		} else {
			Carp::croak join(' ', "can't import", $_, 'in', (caller 0)[3]);
		}
	}
}

sub unimport {
	my $self = shift;
	for (@_) {
		if (defined $Cv::O{$_}) {
			$O{$_} = 0;
		} else {
			Carp::croak join(' ', "can't unimport", $_, 'in', (caller 0)[3]);
		}
	}
}


package Cv;

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


package Cv::Mat;

{
	no warnings 'redefine';
	*new = sub { goto &m_new };
}

sub m_new {
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_ ? shift : $self->type;
	my $mat;
	if (@$sizes) {
		my ($rows, $cols) = @$sizes; $cols ||= 1;
		if (@_) {
			my ($data, $step) = @_;
			$step = &Cv::CV_AUTOSTEP unless $step;
			$mat = Cv::cvCreateMatHeader($rows, $cols, $type);
			$mat->setData($data, $step) if $data;
		} else {
			$mat = Cv::cvCreateMat($rows, $cols, $type);
		}
	} elsif (@_) {
		my @dims = Cv::m_dims(@_);
		pop(@dims) if $dims[-1] == &Cv::CV_MAT_CN($type);
		return undef unless my ($rows, $cols) = @dims; $cols ||= 1;
		$mat = Cv::cvCreateMat($rows, $cols, $type);
		local $Carp::CarpLevel = $Carp::CarpLevel + 2;
		$mat->m_set([], \@_);
	}
	$mat;
}


package Cv::MatND;

{
	no warnings 'redefine';
	*new = \&m_new;
}

sub m_new {
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_ ? shift : $self->type;
	my $mat;
	if (@$sizes) {
		if (@_) {
			$mat = Cv::cvCreateMatNDHeader($sizes, $type);
			$mat->setData($_[0], &Cv::CV_AUTOSTEP) if $_[0];
		} else {
			$mat = Cv::cvCreateMatND($sizes, $type);
		}
	} elsif (@_) {
		my @dims = Cv::m_dims(@_);
		pop(@dims) if $dims[-1] == &Cv::CV_MAT_CN($type);
		$mat = Cv::cvCreateMatND(\@dims, $type);
		local $Carp::CarpLevel = $Carp::CarpLevel + 1;
		$mat->m_set([], \@_);
	}
	$mat;
}

# ============================================================
#  core. The Core Functionality: Operations on Arrays
# ============================================================

package Cv::Arr;

{
	no warnings 'redefine';
	*Set = *set = \&m_set;
}

sub m_set {
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
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


sub m_get {
	my $arr = shift;
	my $idx = shift;
	cvGetDims($arr, my @dims);
	if (@dims <= @$idx) {
		my $type = cvGetElemType($arr);
		[ @{ cvGetND($arr, $idx) }[0 .. Cv::CV_MAT_CN($type) - 1] ];
	} else {
		[ map { $arr->m_get([@$idx, $_]) } (0 .. $dims[scalar @$idx] - 1) ];
	}
}


use overload
	'@{}' => sub { $_[0]->ToArray },
	bool => sub { $_[0] },
	'<=>' => \&overload_cmp,
	cmp => \&overload_cmp,
	fallback => undef;

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


# ============================================================
#  core. The Core Functionality: Dynamic Structures
# ============================================================

{ *Cv::Seq::Point::ToArray = \&ToArray }
{ *Cv::Seq::Point::CvtSeqToArray = \&ToArray }
{ *Cv::Arr::CvtMatToArray = \&ToArray }

sub ToArray {
	# @array = cvtSeqToArray($seq)
	# @array = cvtSeqToArray($seq, $slice)
	# cvtSeqToArray($seq, \@array)
	# cvtSeqToArray($seq, \@array, $slice)
	my $self = CORE::shift;
	my $slice = ref $_[-1] eq 'ARRAY' && @{$_[-1]} == 2?
		CORE::pop : &Cv::CV_WHOLE_SEQ;
	if (@_ >= 1 && ref $_[0] eq 'ARRAY') {
		@{$_[0]} = ();
	} else {
		$_[0] = [];
	}
	if ($self->isa('Cv::Seq::Point')) {
		cvCvtSeqToArray($self, my $string, $slice);
		$self->UnpackMulti($_[0], $string);
	} else {
		my ($start, $end) = @$slice;
		if ($self->isa('Cv::MatND') && $self->dims == 1) {
			$end = $self->rows - 1 if $end == Cv::CV_WHOLE_SEQ_END_INDEX;
			@{$_[0]} = map { $self->get([$_]) } $start .. $end;
		} elsif ($self->cols == 1) {
			$end = $self->rows - 1 if $end == Cv::CV_WHOLE_SEQ_END_INDEX;
			@{$_[0]} = map { $self->get([$_, 0]) } $start .. $end;
		} elsif ($self->rows == 1) {
			$end = $self->cols - 1 if $end == Cv::CV_WHOLE_SEQ_END_INDEX;
			@{$_[0]} = map { $self->get([0, $_]) } $start .. $end;
		} else {
			Carp::croak join(' ', "can't convert", join('x', $self->getDims),
							 'in', (caller 0)[3]);
		}
	}
	wantarray? @{$_[0]} : $_[0];
}


# ============================================================
#  imgproc. Image Processing: Geometric Image Transformations
# ============================================================

package Cv::Arr;

sub Affine {
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	my $map = shift;
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	GetQuadrangleSubPix($src, $dst, Cv::Mat->new([], &Cv::CV_32FC1, @$map));
}


{ *Cv::Transform = \&Transform }
sub Transform {
	# cvTransform(CvArr* src, CvArr* dst, CvMat* transmat, CvMat* shiftvec)
	my $self = shift;
	my $cs = 0;
	unless (ref $self) {
		my $points = shift;
		my @dims = Cv::m_dims(@$points);
		$self = Cv::Mat->new([], &Cv::CV_32FC($dims[-1]), @$points);
		$cs++;
	}
	if (ref $_[0] && $_[0]->isa('Cv::Mat') &&
		$_[0]->rows == 2 && $_[0]->cols == 3) { # $_[0] is transmat
		unshift(@_, $self->new);
	} else {
		$_[0] ||= $self->new;
	}
	unshift(@_, $self);
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $retval = &cvTransform;
	if ($cs) {
		@{ $_[1] = [] } = @$retval;
		if (wantarray) {
			return @{$_[1]} if $Cv::O{cs};
			local $Carp::CarpLevel = $Carp::CarpLevel + 1;
			Carp::carp $Cv::M{butscalar} if $Cv::O{'cs-warn'}
		}
		return $_[1];
	}
	$retval;
}


# ============================================================
#  imgproc. Image Processing: Structural Analysis and Shape Descriptors
# ============================================================

package Cv::Arr;

{ *Cv::BoundingRect = \&BoundingRect }
sub BoundingRect {
	# CvRect cvBoundingRect(CvArr* points, int update=0)
	my $self = shift;
	unless (ref $self) {
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $retval = cvBoundingRect($self);
	if (wantarray) {
		return @$retval if $Cv::O{cs};
		local $Carp::CarpLevel = $Carp::CarpLevel + 1;
		Carp::carp $Cv::M{butscalar} if $Cv::O{'cs-warn'}
	}
	return $retval;
}

{ *Cv::ContourArea = \&ContourArea }
sub ContourArea {
	# double cvContourArea(const CvArr* contour, CvSlice slice=CV_WHOLE_SEQ)
	my $self = shift;
	unless (ref $self) {
		my $points = shift;
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @$points);
	}
	my $slice = shift || &Cv::CV_WHOLE_SEQ;
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	cvContourArea($self, $slice);
}

{ *FitEllipse = \&FitEllipse2 }
{ *Cv::FitEllipse = *Cv::FitEllipse2 = \&FitEllipse2 }
sub FitEllipse2 {
	# Cv->FitEllipse2(\@points);                                                
	# Cv->FitEllipse2(pt1, pt2, pt3, ...);                                      
	# $mat->FitEllipse2;                                                        
	my $self = shift;
	unless (ref $self) {
		Carp::croak "Usage: ${[ caller 0 ]}[3](points)"
			unless @_;
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $retval = cvFitEllipse2($self);
	if (wantarray) {
		return @$retval if $Cv::O{cs};
		local $Carp::CarpLevel = $Carp::CarpLevel + 1;
		Carp::carp $Cv::M{butscalar} if $Cv::O{'cs-warn'};
	}
	return $retval;
}

{ *Cv::FitLine = \&FitLine }
sub FitLine {
    my $self = shift;
    unless (ref $self) {
		my $points = shift;
		Carp::croak "Usage: ${[ caller 0 ]}[3](points, distType=CV_DIST_L2, param=0, reps=0.01, aeps=0.01)"
			unless defined $points;
		Carp::croak "points is not [ pt1, pt2, ... ] in ", (caller 0)[3]
			unless my @dims = Cv::m_dims(@$points);
		$self = Cv::Mat->new([], &Cv::CV_32FC($dims[-1]), @$points);
    }
	my $rr = \ [ ];			# dummy
	if (@_ && (!defined $_[-1] || ref $_[-1] eq 'ARRAY')) {
		$rr = \ $_[-1]; pop;
	}
	my ($distType, $param, $reps, $aeps) = @_;
	$distType ||= &Cv::CV_DIST_L2;
	$param    ||= 0;
	$reps     ||= 0.01;
	$aeps     ||= 0.01;
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	cvFitLine($self, $distType, $param, $reps, $aeps, $$rr);
	my $retval = $$rr;
	if (wantarray) {
		return @$retval if $Cv::O{cs};
		local $Carp::CarpLevel = $Carp::CarpLevel + 1;
		Carp::carp $Cv::M{butscalar} if $Cv::O{'cs-warn'};
	}
	return $retval;
}

{ *MinAreaRect = \&MinAreaRect2 }
{ *Cv::MinAreaRect = *Cv::MinAreaRect2 = \&MinAreaRect2 }
sub MinAreaRect2 {
    my $self = shift;
	&Cv::Seq::stor(\@_);		# remove memstorage;
    unless (ref $self) {
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $retval = cvMinAreaRect2($self);
	if (wantarray) {
		return @$retval if $Cv::O{cs};
		local $Carp::CarpLevel = $Carp::CarpLevel + 1;
		Carp::carp $Cv::M{butscalar} if $Cv::O{'cs-warn'};
	}
	return $retval;
}

{ *Cv::MinEnclosingCircle = \&MinEnclosingCircle }
sub MinEnclosingCircle {
	my $self = shift;
	my ($xcenter, $xradius);	# dummy
	my ($rcenter, $rradius) = (\$xcenter, \$xradius);
	if (@_ >= 2 &&
		# undef or scalar
		(!defined $_[-2] || !ref $_[-2]) &&
		(!defined $_[-1] || !ref $_[-1])) {
		($rcenter, $rradius) = (\$_[-2], \$_[-1]);
		pop; pop;
	}
    unless (ref $self) {
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @_);
		Carp::croak $@ if $@;
	}
	local $Carp::CarpLevel = $Carp::CarpLevel + 1;
	my $retval = cvMinEnclosingCircle($self, $$rcenter, $$rradius)?
		[$$rcenter, $$rradius] : undef;
	if (wantarray) {
		return @$retval if $Cv::O{cs};
		local $Carp::CarpLevel = $Carp::CarpLevel + 1;
		Carp::carp $Cv::M{butscalar} if $Cv::O{'cs-warn'};
	}
	return $retval;
}


# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

package Cv;

sub GetBuildInformation {
	ref (my $class = shift) and Carp::croak 'class name needed';
	our $BuildInformation;
	if (Cv->version >= 2.004) {
		$BuildInformation = cvGetBuildInformation()
			unless defined $BuildInformation;
	}
	$BuildInformation ||= '';
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
	ref (my $class = shift) and Carp::croak 'class name needed';
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

1;
