# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Typemap;

use 5.014002;
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
XSLoader::load('Cv::Typemap', $VERSION);

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Cv::Typemap - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Cv::Typemap;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Cv::Typemap, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

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
