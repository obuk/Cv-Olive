# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

package Cv::Test;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	is_
	err_is
	err_like
	_e e
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = @EXPORT_OK;

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('Cv::Test', $VERSION);

our @CALLER; #($package, $filename, $line);

sub err_is ($;$) {
	my $m = shift;
	if ($m && $@) {
		chomp(my $e = $@);
		$e =~ s/\.$//;
		unshift(@_, $e, "$m at $CALLER[1] line $CALLER[2]");
	} else {
		unshift(@_, $@, $m);
	}
	goto &Test::More::is;
}

sub err_like ($;$) {
	my $m = shift;
	if ($m && $@) {
		chomp(my $e = $@);
		$e =~ s/\.$//;
		unshift(@_, $e, qr/$m.* at $CALLER[1] line $CALLER[2]/);
	} else {
		unshift(@_, $@, $m);
	}
	goto &Test::More::like;
}

sub _e {
	my $i = shift || 0;
	@CALLER = caller($i);
}

sub e (&) {
	_e(1);
	local $Carp::Internal{'Cv::Test'} = 1;
	eval { &{$_[0]} };
}

sub round_deeply {
	my $format = shift;
	if (ref $_[0] eq 'ARRAY') {
		round_deeply($format, $_) for @{$_[0]};
	} else {
		$_[0] = sprintf($format, $_[0]) + 0;
	}
	$_[0];
}

sub is_ {
	my $opt = ref $_[0] && ref $_[0] eq 'HASH' ? shift : { };
	my ($got, $exp) = splice(@_, 0, 2);
	if (my $round = $opt->{round}) {
		$got = round_deeply($round, $got);
		$exp = round_deeply($round, $exp);
	}
	if (my $rotate = $opt->{rotate}) {
		my $len = scalar @$exp;
		my $dim = scalar @{$exp->[0]};
		my @delta;
		for my $i (0 .. $len - 1) {
			my $delta = 0;
			for my $j (0 .. $len - 1) {
				$delta += abs($got->[($i + $j) % $len]->[$_] - $exp->[$j]->[$_])
					for 0 .. $dim - 1;
			}
			push(@delta, [$delta, $i]);
		}
		@delta = sort { $a->[0] <=> $b->[0] } @delta;
		if (my $shift = $delta[0]->[1]) {
			my @tmp = splice(@$got, 0, $shift);
			push(@$got, @tmp);
		}
	}
	unshift(@_, $got, $exp);
	goto &Test::More::is_deeply;
}

1;
__END__
=encoding utf8

=head1 NAME

Cv::Test - Cv extension for internal testing

=head1 SYNOPSIS

  use Cv::Test;

=head1 DESCRIPTION

This module provides functions for internal testing.  e.g. test the
typemap of Cv.  If you use this module, It's a harmless but you got
nothing to be obtained.

=head2 EXPORT

None by default.


=head1 SEE ALSO

http://github.com/obuk/Cv-Olive


=head1 AUTHOR

MASUDA Yuta E<lt>yuta.cpan@gmail.comE<gt>

=head1 LICENCE

Copyright (c) 2010, 2011, 2012 by Masuda Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
