# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::SURFDescriptor;

use 5.008008;
use strict;
use warnings;

use Cv::Seq::Point;

our $VERSION = '0.30';
our @ISA = qw(Cv::Seq::Point);

{ no strict 'refs'; *AUTOLOAD = \&Cv::autoload; }

our $N = 128;					# XXXX - extended ? 128 : 64

sub template {
	my $self = CORE::shift;
	my ($t, $c) = ("f$N", $N);
	wantarray? ($t, $c) : $t;
}

1;
