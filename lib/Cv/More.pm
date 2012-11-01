# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::More;

use 5.008008;
use strict;
use warnings;

our %O = map { $_ => 0 } qw(cs cs-warn);

our %M = (
	butscalar => "called in list context, but returning scaler",
	);

sub import {
	my $self = shift;
	for (@_) {
		if (defined $O{$_}) {
			# Carp::carp "Cv::More: $_: imported";
			$O{$_} = 1;
		} else {
			Carp::carp "Cv::More: can't import $_";
		}
	}
}

sub unimport {
	my $self = shift;
	for (@_) {
		if (defined $O{$_}) {
			# Carp::carp "Cv::More: $_: unimported";
			$O{$_} = 0;
		} else {
			Carp::carp "Cv::More: can't unimport $_";
		}
	}
}


# use Cv qw( );
use Cv::Seq::Point;

package Cv;

sub m_croak {
	chomp(my ($e) = @_);
	$e =~ s/\s*(in|file|line|at) .*$//;
	@_ = ($e);
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
		return undef unless my @dims = m_dims(@_);
		pop(@dims) if $dims[-1] == &Cv::CV_MAT_CN($type);
		return undef unless my ($rows, $cols) = @dims; $cols ||= 1;
		$mat = Cv::cvCreateMat($rows, $cols, $type);
		$mat->Set([], \@_);
	}
	$mat;
}

package Cv::Arr;

{
	no warnings 'redefine';
	*Set = *set = sub {
		eval { &m_set(@_) };
		Cv::m_croak $@ if $@;
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
	Cv::m_croak $@ if $@;
	$src;
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
	my $retval = eval { cvBoundingRect(@_) };
	Cv::m_croak $@ if $@;
	if (wantarray) {
		return @$retval if $Cv::More::O{cs};
		Carp::carp $Cv::More::M{butscalar} if $Cv::More::O{'cs-warn'}
	}
	return $retval;
}

package Cv::Arr;

{ *FitEllipse = \&FitEllipse2 }
{ *Cv::FitEllipse = *Cv::FitEllipse2 = \&FitEllipse2 }
sub FitEllipse2 {
	# Cv->FitEllipse2(\@points);                                                
	# Cv->FitEllipse2(pt1, pt2, pt3, ...);                                      
	# $mat->FitEllipse2;                                                        
	my $self = shift;
	unless (ref $self) {
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	my $retval = eval { cvFitEllipse2($self) };
	Cv::m_croak $@ if $@;
	if (wantarray) {
		return @$retval if $Cv::More::O{cs};
		Carp::carp $Cv::More::M{butscalar} if $Cv::More::O{'cs-warn'};
	}
	return $retval;
}


{ *Cv::FitLine = \&FitLine }
sub FitLine {
    my $self = shift;
    unless (ref $self) {
		my $points = shift;
		my @dims = Cv::m_dims(@$points);
		$self = eval { Cv::Mat->new([], &Cv::CV_32FC($dims[-1]), @$points) };
		Cv::m_croak $@ if $@;
    }
	my $rr = \ [ ];			# dummy
	if (@_ && (!defined $_[-1] || ref $_[-1] eq 'ARRAY')) {
		$rr = \ $_[-1]; pop;
	}
	my ($distType, $param, $reps, $aeps) = @_;
	$distType //= &Cv::CV_DIST_L2;
	$param    //= 0;
	$reps     //= 0.01;
	$aeps     //= 0.01;
	eval { cvFitLine($self, $distType, $param, $reps, $aeps, $$rr) };
	Cv::m_croak $@ if $@;
	my $retval = $$rr;
	if (wantarray) {
		return @$retval if $Cv::More::O{cs};
		Carp::carp $Cv::More::M{butscalar} if $Cv::More::O{'cs-warn'};
	}
	return $retval;
}


{ *MinAreaRect = \&MinAreaRect2 }
{ *Cv::MinAreaRect = *Cv::MinAreaRect2 = \&MinAreaRect2 }
sub MinAreaRect2 {
    my $self = shift;
    unless (ref $self) {
		$self = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	my $retval = eval { cvMinAreaRect2($self) };
	Cv::m_croak $@ if $@;
	if (wantarray) {
		return @$retval if $Cv::More::O{cs};
		Carp::carp $Cv::More::M{butscalar} if $Cv::More::O{'cs-warn'};
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
	}
	my $retval = eval {
		cvMinEnclosingCircle($self, $$rcenter, $$rradius)?
			[$$rcenter, $$rradius] : undef;
	};
	Cv::m_croak $@ if $@;
	if (wantarray) {
		return @$retval if $Cv::More::O{cs};
		Carp::carp $Cv::More::M{butscalar} if $Cv::More::O{'cs-warn'};
	}
	return $retval;
}

1;
