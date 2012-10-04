# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::More;

use 5.008008;
use strict;
use warnings;

# ============================================================
#  core. The Core Functionality: Dynamic Structures
# ============================================================

=head2 Use Perl Array

The Sequence of OpenCV stores the various data, e.g. points,
rectangles, and circles.  And it has also similarity with the array
of Perl.  However, its handling is a little difficult.  So we made a
superclass Cv::Seq that handles all data without regard to the type of
data to be stored in the sequence.  And we made derived class to
handle specific data types,​e.g. Cv::Seq::Point, Cv::Seq::Rect.  Then,
we bless with derived classes to fit the data to be stored.  It is
similar to the cast in the language C.

There is a part of the facedetect as follows.  We can use only a
string data if we don't know the data type of the sequence.  But we
can convert using pack/unpack indirectly if we know that.

  my $faces = bless $image->HaarDetectObjects(
	$cascade, $storage, 1.1, 2, CV_HAAR_SCALE_IMAGE,
	cvSize(30, 30)), "Cv::Seq::Rect";
  while (my @rect = $faces->shift) {
    ...
  }

We made the functions​Push(), Pop(), Shift(), Unshift(), and and
Splice() to mimic the functions to manipulate sequences that operate
on an array of Perl.  Cv::Seq::Point handles the sequence of points,
and that is often used, so we also made new.  The following example
calculates $center and $radius from the Perl data.

 my @points = ([ 100, 100 ], [ 100, 200 ], [ 200, 100 ]);
 Cv::Seq::Point->new(&Cv::CV_32SC2)->push(@points)
	->minEnclosingCircle(my $center, my $radius);

=cut

=xxx

package Cv;

sub is_cvmem { blessed $_[0] && $_[0]->isa('Cv::MemStorage') }

package Cv::Seq;

our $STORAGE;

sub STORAGE {
	$STORAGE ||= Cv::MemStorage->new();
}

sub stor (\@) {
	my $storage;
	for (my $i = 0; $i < @{$_[0]}; $i++) {
		($storage) = splice(@{$_[0]}, $i, 1), last
			if Cv::is_cvmem(${$_[0]}[$i]);
	}
	$storage ||= &STORAGE;
}

sub Cv::CreateSeq {
	ref (my $class = shift) and Cv::croak 'class name needed';
	Cv::Seq->new(@_)
}

{ *new = \&CreateSeq }
sub CreateSeq {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $stor = stor(@_);
	my $seqFlags = CORE::shift;
	$seqFlags = &Cv::CV_32SC2 unless defined $seqFlags;
	my $headerSize = CORE::shift || &Cv::CV_SIZEOF('CvSeq');
	my $elemSize = CORE::shift || &Cv::CV_ELEM_SIZE($seqFlags);
	bless Cv::cvCreateSeq($seqFlags, $headerSize, $elemSize, $stor), $class;
}


sub MakeSeqHeaderForArray {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $seqFlags = CORE::shift;
	$seqFlags = &Cv::CV_32SC2 unless defined $seqFlags;
	my $headerSize = CORE::shift || &Cv::CV_SIZEOF('CvSeq');
	my $elemSize = CORE::shift || &Cv::CV_ELEM_SIZE($seqFlags);
	bless Cv::cvMakeSeqHeaderForArray($seqFlags, $headerSize, $elemSize, @_), $class;
}

=cut

package Cv::Seq;

our %TEMPLATE;

sub template {
	my $self = CORE::shift;
	unless (defined $TEMPLATE{&Cv::CV_32SC2}) {
		foreach my $cn (1 .. 4) {
			$TEMPLATE{&Cv::CV_8SC(  $cn )} = [ "c$cn", $cn ];
			$TEMPLATE{&Cv::CV_8UC(  $cn )} = [ "C$cn", $cn ];
			$TEMPLATE{&Cv::CV_16SC( $cn )} = [ "s$cn", $cn ];
			$TEMPLATE{&Cv::CV_16UC( $cn )} = [ "S$cn", $cn ];
			$TEMPLATE{&Cv::CV_32SC( $cn )} = [ "i$cn", $cn ];
			$TEMPLATE{&Cv::CV_32FC( $cn )} = [ "f$cn", $cn ];
			$TEMPLATE{&Cv::CV_64FC( $cn )} = [ "d$cn", $cn ];

		}
	}
	return undef unless ref $self && $self->UNIVERSAL::can('mat_type');
	wantarray ? @{$TEMPLATE{$self->mat_type}} : $TEMPLATE{$self->mat_type}[0];
}


=xxx

sub Pop {
	my $self = CORE::shift;
	$self->cvSeqPop;
}


sub Push {
	my $self = CORE::shift;
	$self->cvSeqPush($_) for @_;
	$self;
}


sub Shift {
	my $self = CORE::shift;
	$self->cvSeqPopFront;
}


sub Unshift {
	my $self = CORE::shift;
	$self->cvSeqPushFront($_) for @_;
	$self;
}


sub Splice {
	# splice($array, $offset, $length, @list)
	# splice($array, $offset, $length)
	# splice($array, $offset)
	my $array = CORE::shift;
	my $offset = CORE::shift;
	my $length = @_? CORE::shift : $array->total - $offset;
	my @le = ();
	foreach (0 .. $offset - 1) {
		CORE::push(@le, scalar $array->Shift);
	}
	my @ce = ();
	foreach (0 .. $length - 1) {
		CORE::push(@ce, scalar $array->Shift);
	}
	$array->Unshift(@le, @_);
	wantarray? @ce : \@ce;
}

=cut

package Cv::Seq::Point;

{ *new = \&CreateSeq }
sub CreateSeq {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	$class->SUPER::new(@_);
}


=pod

ToArray() convert from the sequence to the Perl array.  The following
code draws all circles stored in the sequence $circles.

 $img->circle($_->[0], $_->[1], CV_RGB(0, 255, 0), 3)
	for $circles->toArray;

ToArray() overrides @{}, so you can write it more easily.

 $img->circle($_->[0], $_->[1], CV_RGB(0, 255, 0), 3)
	for @$circles;

=cut

{
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
		Cv::croak "$0: can't overload ", ref $_[0], "::", $_[3]
	}

}

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


{ *Get = \&GetSeqElem }
sub GetSeqElem {
	my $self = CORE::shift;
	my $index = CORE::shift;
	my @pt = $self->Unpack($self->SUPER::GetSeqElem($index));
	wantarray? @pt : \@pt;
}


{ *Set = \&SetSeqElem }
sub SetSeqElem {
	my $self = CORE::shift;
	my $index = CORE::shift;
	$self->SUPER::SetSeqElem($index, $self->Pack(@_));
}


sub Push {
	my $self = CORE::shift;
	$self->SUPER::Push($self->Pack(@$_)) for @_;
	$self;
}


sub Pop {
	my $self = CORE::shift;
	my @pt = $self->Unpack($self->SUPER::Pop);
	wantarray? @pt : \@pt;
}


sub Shift {
	my $self = CORE::shift;
	my @pt = $self->Unpack($self->SUPER::Shift);
	wantarray? @pt : \@pt;
}


sub Unshift {
	my $self = CORE::shift;
	$self->SUPER::Unshift($self->Pack(@$_)) for @_;
	$self;
}


sub MakeSeqHeaderForArray {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	$class->SUPER::MakeSeqHeaderForArray(@_);
}


sub Pack {
	my $self = CORE::shift;
	my $t = $self->template;
	CORE::pack($t, map { ref $_ ? @$_ : $_ } @_);
}


sub Unpack {
	my $self = CORE::shift;
	my $t = $self->template;
	no warnings 'uninitialized';
	CORE::unpack($t, $_[0]);
}


sub UnpackMulti {
	my $self = CORE::shift;
	my ($t, $c) = $self->template;
	no warnings 'uninitialized';
	my @data = CORE::unpack("($t)*", $_[1]);
	while (my @elem = CORE::splice(@data, 0, $c)) {
		CORE::push(@{$_[0]}, \@elem);
	}
}


package Cv::Seq::Rect;

sub template {
	my $self = CORE::shift;
	my ($t, $c) = ("i4", 4);
	wantarray? ($t, $c) : $t;
}


package Cv::Seq::SURFPoint;

sub template {
	my $self = CORE::shift;
	my ($t, $c) = ("f2i2f2", 6);
	wantarray? ($t, $c) : $t;
}


sub Pack {
	my $self = CORE::shift;
	my $t = $self->template;
	CORE::pack($t, @{$_[0]}, @_[1..$#_]);
}


sub Unpack {
	my $self = CORE::shift;
	my $t = $self->template;
	no warnings 'uninitialized';
	my ($x, $y, @r) = CORE::unpack($t, $_[0]);
	my @elem = ([ $x, $y ], @r);
	wantarray? @elem : \@elem;
}


sub UnpackMulti {
	my $self = CORE::shift;
	my ($t, $c) = $self->template;
	no warnings 'uninitialized';
	my @data = CORE::unpack("($t)*", $_[1]);
	while (my ($x, $y, @r) = CORE::splice(@data, 0, $c)) {
		CORE::push(@{$_[0]}, [[$x, $y], @r]);
	}
}

# package Cv::MemStorage;
# { *new = \&Cv::CreateMemStorage }

package Cv::Seq::Seq;
{ *Get = \&GetSeqElem }

package Cv::Seq;
# { *cvCvtSeqToArray = \&Cv::Arr::cvCvtSeqToArray }
# { *cvGetSeqElem = \&Cv::Arr::cvGetSeqElem }
# { *cvSetSeqElem = \&Cv::Arr::cvSetSeqElem }
# { *cvSeqInvert = \&Cv::Arr::cvSeqInvert }

# { *ToArray = \&CvtSeqToArray }
# { *Get = \&GetSeqElem }
# { *Set = \&SetSeqElem }
# { *Invert = *Reverse = *SeqInvert = \&SeqInvert }

# package Cv::Arr;
# { *Get = \&GetND }
# { *Set = \&SetND }


package Cv;

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
	if (0) {
		my $type = &Cv::CV_32FC(scalar @{$arr->[0]});
		my $points = Cv::Seq::Point->new($type, &Cv::Seq::STORAGE);
		$points->Push(@$arr);
		unshift(@_, $points);
	} else {
		my $type = &Cv::CV_32FC(scalar @{$arr->[0]});
		my $len = scalar @$arr;
		my $points = Cv->CreateMat($len, 1, $type);
		$points->Set([$_], $arr->[$_]) for 0 .. $len - 1;
		unshift(@_, $points);
	}
	goto &Cv::Arr::cvFitLine;
}

{ *FitEllipse = \&FitEllipse2 }
sub FitEllipse2 {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $stor = Cv::Seq::stor(@_);
	my $points = Cv::Seq::Point->new(&Cv::CV_32SC2, $stor);
	$points->Push(@_ > 1 ? @_ : @{$_[0]});
	$points->FitEllipse2;
}

{ *MinAreaRect = \&MinAreaRect2 }
sub MinAreaRect2 {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $stor = Cv::Seq::stor(@_);
	my $points = Cv::Seq::Point->new(&Cv::CV_32SC2, $stor);
	$points->Push(@_ > 1 ? @_ : @{$_[0]});
	$points->minAreaRect2($stor);
}

sub MinEnclosingCircle {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $stor = Cv::Seq::stor(@_);
	my $points = Cv::Seq::Point->new(&Cv::CV_32SC2, $stor);
	$points->Push(@_ > 1 ? @_ : @{$_[0]});
	$points->minEnclosingCircle(my $center, my $radius);
	wantarray? ($center, $radius) : [$center, $radius];
}

sub ContourArea {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	my $stor = Cv::Seq::stor(@_);
	my $points = Cv::Seq::Point->new(&Cv::CV_32SC2 | CV_SEQ_POLYLINE, $stor);
	$points->Push(@_ > 1 ? @_ : @{$_[0]});
	$points->ContourArea;
}


package Cv::Arr;

{ *ToArray = \&CvtMatToArray }
sub CvtMatToArray {
	my $mat = shift;
	if (Cv::CV_MAT_CN($mat->type) == 1) {
		my @arr = unpack("f*", $mat->ptr);
		wantarray? @arr : \@arr;
	} else {
		my $seq = &cvPointSeqFromMat($mat, $mat->type, my $header, my $block);
		my $arr = Cv::Seq::Point::CvtSeqToArray($seq);
		wantarray? @$arr : $arr;
	}
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
	*Cv::cvCreateOpenGLCallback = sub { croak "no Qt" };
}


1;
__END__
