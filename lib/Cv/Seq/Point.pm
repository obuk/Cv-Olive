# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Point;

use 5.008008;
use strict;
use warnings;

use Cv::Seq;

our @ISA = qw(Cv::Seq);

{
	no warnings 'redefine';
	sub AUTOLOAD { &Cv::autoload };
}

{ *new = \&CreateSeq }
sub CreateSeq {
	ref (my $class = CORE::shift) and Cv::croak 'class name needed';
	$class->SUPER::new(@_);
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

1;
