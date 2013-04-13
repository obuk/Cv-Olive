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

our $VERSION = '0.26';

require XSLoader;
XSLoader::load('Cv::BGCodeBookModel', $VERSION);

require Exporter;

our @EXPORT_OK = grep /^(IPL|CV|cv)/, (keys %Cv::BGCodeBookModel::);

our %EXPORT_TAGS = (
	'all' => \@EXPORT_OK,
	);

our @EXPORT = ( );

push(@Cv::EXPORT_OK, @EXPORT_OK);

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

Copyright (c) 2013 by MASUDA Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
