# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

package MY;

use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	err_is
	err_like
	_e e
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = @EXPORT_OK;

our $VERSION = '0.01';

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
	local $Carp::CarpLevel = $Carp::CarpLevel + 2;
	eval { &{$_[0]} };
}

1;
