# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Highgui;

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
XSLoader::load('Cv::Highgui', $VERSION);

# Preloaded methods go here.

package Cv::Capture;

{ no strict 'refs'; *AUTOLOAD = \&Cv::autoload; }

package Cv::VideoWriter;

{ no strict 'refs'; *AUTOLOAD = \&Cv::autoload; }

# ============================================================
#  highgui. High-level GUI and Media I/O: User Interface
# ============================================================

package Cv;

our %MOUSE = ( );
our %TRACKBAR = ( );

package Cv::Arr;
{ *Show = \&ShowImage }

# ============================================================
#  highgui. High-level GUI and Media I/O: Reading and Writing Images and Video
# ============================================================

package Cv::Arr;

sub EncodeImage {
	$_[2] = my $params = \0 unless defined $_[2];
	goto &cvEncodeImage;
}

package Cv::Image;
{ *Load = \&Cv::LoadImage }

package Cv::Mat;
{ *Load = \&Cv::LoadImageM }

package Cv::Arr;
{ *Save = \&SaveImage }

package Cv::Capture;
{ *FromCAM = \&Cv::CaptureFromCAM }
{ *FromFile = *FromAVI = \&Cv::CaptureFromFile }
{ *GetProperty = \&GetCaptureProperty }
{ *Grab = \&GrabFrame }
{ *Query = \&QueryFrame }
{ *Retrieve = \&RetrieveFrame }
{ *SetProperty = \&SetCaptureProperty }

package Cv::VideoWriter;
{ *new = \&Cv::CreateVideoWriter }


# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

1;
__END__
=head1 NAME

Cv::Highgui - Perl extension for OpenCV high module

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

=head1 SEE ALSO

=head1 AUTHOR

MASUDA Yuta E<lt>yuta.cpan@gmail.comE<gt>

=head1 LICENCE

Copyright (c) 2010, 2011, 2012 by Masuda Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
