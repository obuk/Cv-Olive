# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Point2;

use 5.008008;
use strict;
use warnings;
use Cv;
# use Cv::Seq::Point;

our $VERSION = '0.14';

require Exporter;

our @ISA = qw(Exporter Cv::Seq::Point);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

sub AUTOLOAD { &Cv::autoload };

sub template {
	my $self = CORE::shift;
	my ($t, $c) = ("i4", 4);
	wantarray? ($t, $c) : $t;
}


sub Pack {
	my $self = CORE::shift;
	my $t = $self->template;
	CORE::pack($t, @{$_[0]}, @{$_[1]},);
}


sub Unpack {
	my $self = CORE::shift;
	my $t = $self->template;
	no warnings 'uninitialized';
	my ($x1, $y1, $x2, $y2) = CORE::unpack($t, $_[0]);
	my @elem = ([$x1, $y1], [$x2, $y2]);
	wantarray? @elem : \@elem;
}


sub UnpackMulti {
	my $self = CORE::shift;
	my ($t, $c) = $self->template;
	no warnings 'uninitialized';
	my @data = CORE::unpack("($t)*", $_[1]);
	while (my ($x1, $y1, $x2, $y2) = CORE::splice(@data, 0, $c)) {
		CORE::push(@{$_[0]}, [[$x1, $y1], [$x2, $y2]]);
	}
}

1;
