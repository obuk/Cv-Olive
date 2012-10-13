# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Rect;

use 5.008008;
use strict;
use warnings;

use Cv::Seq::Point;

our @ISA = qw(Cv::Seq::Point);

{
	no warnings 'redefine';
	sub AUTOLOAD { &Cv::autoload };
}

sub template {
	my $self = CORE::shift;
	my ($t, $c) = ("i4", 4);
	wantarray? ($t, $c) : $t;
}

1;
