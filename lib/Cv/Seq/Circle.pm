# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Circle;

use 5.008008;
use strict;
use warnings;
use Cv;
# use Cv::Seq::Point;

our $VERSION = '0.14';

our @ISA = qw(Exporter Cv::Seq::Point);

sub AUTOLOAD { &Cv::autoload };

sub Pack {
	my $self = CORE::shift;
	my $t = $self->template;
	CORE::pack($t, @{$_[0]}, @_[1..$#_]);
}


sub Unpack {
	my $self = CORE::shift;
	my $t = $self->template;
	no warnings 'uninitialized';
	my ($x, $y, $r) = CORE::unpack($t, $_[0]);
	my @elem = ([ $x, $y ], $r);
	wantarray? @elem : \@elem;
}


sub UnpackMulti {
	my $self = CORE::shift;
	my ($t, $c) = $self->template;
	no warnings 'uninitialized';
	my @data = CORE::unpack("($t)*", $_[1]);
	while (my ($x, $y, $r) = CORE::splice(@data, 0, $c)) {
		CORE::push(@{$_[0]}, [[$x, $y], $r]);
	}
}

1;
