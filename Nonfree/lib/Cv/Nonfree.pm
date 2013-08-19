# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::Nonfree - Perl extension for OpenCV Nonfree

=head1 SYNOPSIS

 use Cv::Nonfree;

=cut

package Cv::Nonfree;

use 5.008008;
use strict;
use warnings;
use Cv ();

our $VERSION = '0.30';

require XSLoader;
XSLoader::load('Cv::Nonfree', $VERSION);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = ();

our %EXPORT_TAGS = (
	'all' => \@EXPORT_OK,
	);

our @EXPORT = ( );

# ============================================================
#  nonfree. Non-free functionality
# ============================================================

=head1 DESCRIPTION

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

Copyright (c) 2013 by MASUDA Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
