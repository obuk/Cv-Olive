# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::More;

use 5.008008;
use strict;
use warnings;

# use Cv qw( );
use Cv::Seq::Point;

package Cv;

sub ec (&) {
	my $code = shift;
	my $r;
	eval { $r = &$code };
	if (my $e = $@) {
		chop($e); 1 while ($e =~ s/ at .*$//g);
		Carp::croak $e;
	}
	$r;
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
		my $init = \@_;
		ec { $mat->m_set([], $init) };
	}
	$mat;
}

package Cv::Arr;

{
	no warnings 'redefine';
	*Set = *set = sub {
		my $args = \@_;
		Cv::ec { &m_set(@$args) };
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

package Cv::Arr;

sub ContourArea {
	# ContourArea(IN points)
	my $args = \@_;
	Cv::ec { cvContourArea(@$args) };
}

sub FitLine {
	# FitLine(IN points, IN dist_type, IN param, IN reps, IN aeps, OUT line)
	my $points = shift;
	my $rline = \ [];			# dummy
	if (@_ && (!defined $_[-1] || ref $_[-1] eq 'ARRAY')) {
		$rline = \ $_[-1]; pop;
	}
	my $distType = @_ && shift || &Cv::CV_DIST_L2;
	my $param    = @_ && shift || 0;
	my $reps     = @_ && shift || 0.01;
	my $aeps     = @_ && shift || 0.01;
	Cv::ec {
		cvFitLine($points, $distType, $param, $reps, $aeps, $$rline);
		$$rline;
	};
}


sub FitEllipse2 {
	# FitEllipse2(IN points, OUT box)
	my $points = shift;
	my $xbox;					# dummy
	my $rbox = \ $xbox;
	if (@_ >= 1 && !defined $_[-1]) {
		$rbox = \ $_[-1]; pop;
	}
	Cv::ec {
		@$$rbox = @{ cvFitEllipse2($points) };
		$$rbox;
	};
}


sub MinAreaRect2 {
	# MinAreaRect2(IN points, OUT box)
	my $points = shift;
	my $xbox;					# dummy
	my $rbox = \ $xbox;
	if (@_ >= 1 && !defined $_[-1]) {
		$rbox = \ $_[-1]; pop;
	}
	Cv::ec {
		@$$rbox = @{ cvMinAreaRect2($points) };
		$$rbox;
	};
}


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
	Cv::ec {
		cvMinEnclosingCircle($points, $$rcenter, $$rradius)?
			[$$rcenter, $$rradius] : undef;
	};
}


package Cv;

sub FitLine {
	# cvFitLine(points, dist_type, param, reps, aeps, line)
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $init = shift;
	my $rline = \ [];			# dummy
	if (@_ >= 1 && (!defined $_[-1] || ref $_[-1] eq 'ARRAY')) {
		$rline = \ $_[-1]; pop;
	}
	my @dims = m_dims(@$init);
	my $params = \@_;
	Cv::ec {
		my $points = Cv::Mat->new([], &Cv::CV_32FC($dims[-1]), @$init);
		Cv::Arr::FitLine($points, @$params, $$rline);
	};
}


{ *FitEllipse = \&FitEllipse2 }
sub FitEllipse2 {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $xbox;					# dummy
	my $rbox = \ $xbox;
	if (@_ >= 1 && !defined $_[-1]) {
		$rbox = \ $_[-1]; pop;
	}
	my $init = \@_;
	Cv::ec {
		my $points = Cv::Mat->new([], &Cv::CV_32SC2, @$init);
		Cv::Arr::FitEllipse2($points, $$rbox);
	};
}


{ *MinAreaRect = \&MinAreaRect2 }
sub MinAreaRect2 {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $xbox;					# dummy
	my $rbox = \ $xbox;
	if (@_ >= 1 && !defined $_[-1]) {
		$rbox = \ $_[-1]; pop;
	}
	my $init = \@_;
	Cv::ec {
		my $points = Cv::Mat->new([], &Cv::CV_32SC2, @$init);
		Cv::Arr::MinAreaRect2($points, $$rbox);
	};
}


sub MinEnclosingCircle {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my ($xcenter, $xradius);	# dummy
	my ($rcenter, $rradius) = (\$xcenter, \$xradius);
	if (@_ >= 2 &&
		# undef or scalar
		(!defined $_[-2] || !ref $_[-2]) &&
		(!defined $_[-1] || !ref $_[-1])) {
		($rcenter, $rradius) = (\$_[-2], \$_[-1]);
		pop; pop;
	}
	my $init = \@_;
	Cv::ec {
		my $points = Cv::Mat->new([], &Cv::CV_32SC2, @$init);
		&Cv::Arr::MinEnclosingCircle($points, $$rcenter, $$rradius);
	};
}


sub ContourArea {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $init = \@_;
	Cv::ec {
		my $points = Cv::Mat->new([], &Cv::CV_32SC2, @$init);
		&Cv::Arr::ContourArea($points);
	};
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
