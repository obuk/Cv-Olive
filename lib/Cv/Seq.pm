# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq;

use 5.008008;
use strict;
use warnings;

use Cv::Seq::Point;
use Cv::Seq::Point2;
use Cv::Seq::Circle;
use Cv::Seq::Rect;
use Cv::Seq::SURFPoint;

package Cv::Seq::Seq;

# our @ISA = qw(Cv::Seq);

{ *Get = \&GetSeqElem }

package Cv::Seq;

{
	no warnings 'redefine';
	sub AUTOLOAD { &Cv::autoload };
}

our %TEMPLATE;
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

sub Cv::CreateSeq {
	ref (my $class = shift) and Carp::croak 'class name needed';
	Cv::Seq->new(@_)
}


{ *new = \&CreateSeq }
sub CreateSeq {
	ref (my $class = CORE::shift) and Carp::croak 'class name needed';
	my $stor = stor(@_);
	my $seqFlags = CORE::shift;
	$seqFlags = &Cv::CV_32SC2 unless defined $seqFlags;
	my $headerSize = CORE::shift || &Cv::CV_SIZEOF('CvSeq');
	my $elemSize = CORE::shift || &Cv::CV_ELEM_SIZE($seqFlags);
	bless Cv::cvCreateSeq($seqFlags, $headerSize, $elemSize, $stor), $class;
}


sub MakeSeqHeaderForArray {
	ref (my $class = CORE::shift) and Carp::croak 'class name needed';
	my $seqFlags = CORE::shift;
	$seqFlags = &Cv::CV_32SC2 unless defined $seqFlags;
	my $headerSize = CORE::shift || &Cv::CV_SIZEOF('CvSeq');
	my $elemSize = CORE::shift || &Cv::CV_ELEM_SIZE($seqFlags);
	bless Cv::cvMakeSeqHeaderForArray($seqFlags, $headerSize, $elemSize, @_), $class;
}


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

{ *cvCvtSeqToArray = \&Cv::Arr::cvCvtSeqToArray }
{ *cvGetSeqElem = \&Cv::Arr::cvGetSeqElem }
{ *cvSetSeqElem = \&Cv::Arr::cvSetSeqElem }
{ *cvSeqInvert = \&Cv::Arr::cvSeqInvert }
# { *ToArray = \&CvtSeqToArray }
{ *Get = \&GetSeqElem }
{ *Set = *set = \&SetSeqElem }
{ *Invert = *Reverse = *SeqInvert = \&SeqInvert }

1;
__END__
