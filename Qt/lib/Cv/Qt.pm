# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Qt;

use 5.008008;
use strict;
use warnings;
use Cv ();
require Exporter;

our @ISA = qw(Exporter);

my @cv = qw(
cvSetWindowProperty
cvGetWindowProperty
cvFontQt
cvDisplayOverlay
cvDisplayStatusBar
cvSaveWindowParameters
cvLoadWindowParameters
);

my @cvarr = qw(
cvAddText
);

our %EXPORT_TAGS = ( 'all' => [ @cv, @cvarr ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ();

our $VERSION = '0.25';

require XSLoader;
XSLoader::load('Cv::Qt', $VERSION);

for (@cvarr) {
	(my $short = $_) =~ s/^cv//;
	eval <<"----";
	sub Cv::Arr::$short {
		goto \&Cv::Qt::$_;
	}
----
	;
}

for (@cv) {
	(my $short = $_) =~ s/^cv//;
	eval <<"----";
	sub Cv::$short {
		ref (my \$class = shift) and Carp::croak 'class name needed';
		goto \&Cv::Qt::$_;
	}
----
	;
}

1;
__END__
=encoding utf8

=head1 NAME

Cv::Qt - Cv extension for Qt

=head1 SYNOPSIS

  use Cv::Qt;

=head1 DESCRIPTION

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
