# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::BGCodeBookModel - Perl extension for OpenCV BGCodeBookModel

=head1 SYNOPSIS

 use Cv::BGCodeBookModel;

=cut

package Cv::BGCodeBookModel;

use 5.008008;
use strict;
use warnings;
use Cv ();
require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
	# 'all' => [ grep { /^cv/ } keys %Cv::BGCodeBookModel:: ],
	'all' => [ grep { /^cv/ } keys %Cv:: ],
	);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( );

our $VERSION = '0.26';

require XSLoader;
XSLoader::load('Cv::BGCodeBookModel', $VERSION);

*AUTOLOAD = \&Cv::autoload;

# ============================================================
#  Background/foreground segmentation
# ============================================================

=head1 DESCRIPTION

=head2 METHOD

=over

=cut



=back

=cut

1;
__END__

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
