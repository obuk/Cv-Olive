# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::T;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Cv::T', $VERSION);

1;
__END__
=encoding utf8

=head1 NAME

Cv::T - Cv extension for internal testing

=head1 SYNOPSIS

  use Cv::T;

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
