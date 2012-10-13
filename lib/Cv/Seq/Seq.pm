# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Seq;

use 5.008008;
use strict;
use warnings;

use Cv::Seq;

our @ISA = qw(Cv::Seq);

{
	no warnings 'redefine';
	sub AUTOLOAD { &Cv::autoload };
}

{ *Get = \&GetSeqElem }

1;
