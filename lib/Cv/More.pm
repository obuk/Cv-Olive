# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::More;

use 5.008008;
use strict;
use warnings;

use Cv::Seq::Point;

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
		if (my $err = $@) {
			chop($err);
			1 while ($err =~ s/ at .*$//);
			Carp::croak $err;
		}
	}
	$mat;
}

package Cv::Arr;

{
	no warnings 'redefine';
	*Set = *set = sub {
		my $RETVAL = &m_set;
		if (my $err = $@) {
			chop($err);
			1 while ($err =~ s/ at .*$//);
			Carp::croak $err;
		}
		$RETVAL;
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


package Cv;

# ============================================================
#  core. The Core Functionality: Dynamic Structures
# ============================================================

our $USE_SEQ = 0;				# XXXXX

sub FitLine {
	# cvFitLine(points, dist_type, param, reps, aeps, line)
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $arr = shift;
	unless (ref $arr eq 'ARRAY' && ref $arr->[0] eq 'ARRAY' &&
			((scalar @{$arr->[0]} == 2) || (scalar @{$arr->[0]} == 3)) &&
			@_ >= 1) {
		Cv::croak "usage: Cv->FitLine(points, ..., line)";
	}
	my $dist_type = @_ >= 2 && shift || Cv::CV_DIST_L2;
	my $param = @_ >= 2 && shift || 0;
	my $reps = @_ >= 2 && shift || 0.01;
	my $aeps = @_ >= 2 && shift || 0.01;
	unshift(@_, $dist_type, $param, $reps, $aeps);
	my $type = &Cv::CV_32FC(scalar @{$arr->[0]});
	my $points;
	if ($USE_SEQ) {
		$points = Cv::Seq::Point->new($type, &Cv::Seq::STORAGE);
		$points->Push(@$arr);
	} else {
		my $type = &Cv::CV_32FC(scalar @{$arr->[0]});
		$points = Cv::Mat->new([], $type, $arr);
	}
	unshift(@_, $points);
	goto &Cv::Arr::cvFitLine;
}

{ *FitEllipse = \&FitEllipse2 }
sub FitEllipse2 {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $points;
	if ($USE_SEQ) {
		my $stor = Cv::Seq::stor(@_);
		$points = Cv::Seq::Point->new(&Cv::CV_32SC2, $stor);
		$points->Push(@_ > 1 ? @_ : @{$_[0]});
	} else {
		$points = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	$points->FitEllipse2;
}

{ *MinAreaRect = \&MinAreaRect2 }
sub MinAreaRect2 {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $points;
	if ($USE_SEQ) {
		my $stor = Cv::Seq::stor(@_);
		$points = Cv::Seq::Point->new(&Cv::CV_32SC2, $stor);
		$points->Push(@_ > 1 ? @_ : @{$_[0]});
		unshift(@_, $stor);
	} else {
		$points = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	$points->minAreaRect2;
}

sub MinEnclosingCircle {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $points;
	if ($USE_SEQ) {
		my $stor = Cv::Seq::stor(@_);
		$points = Cv::Seq::Point->new(&Cv::CV_32SC2, $stor);
		$points->Push(@_ > 1 ? @_ : @{$_[0]});
	} else {
		$points = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	$points->minEnclosingCircle(my $center, my $radius);
	wantarray? ($center, $radius) : [$center, $radius];
}

sub ContourArea {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $points;
	if ($USE_SEQ) {
		my $stor = Cv::Seq::stor(@_);
		$points = Cv::Seq::Point->new(&Cv::CV_32SC2 | CV_SEQ_POLYLINE, $stor);
		$points->Push(@_ > 1 ? @_ : @{$_[0]});
	} else {
		$points = Cv::Mat->new([], &Cv::CV_32SC2, @_);
	}
	$points->ContourArea;
}


package Cv::Arr;

sub Affine {
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	my $mat = shift;
	my $matrix = Cv::Mat->new([ ], &Cv::CV_32FC1, @$mat);
	unshift(@_, $src, $dst, $matrix);
	goto &GetQuadrangleSubPix;
}

sub matrix {
	my $matrix = shift;
	my $rows = @$matrix;
	my $cols = @{$matrix->[0]};
	my @m = map @$_, @$matrix;
	($rows, $cols, @m);
}


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

1;
