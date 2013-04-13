# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::Subdiv2D - Perl extension for OpenCV Subdiv2D

=head1 SYNOPSIS

 use Cv::Subdiv2D;

=cut

package Cv::Subdiv2D;

use 5.008008;
use strict;
use warnings;
use Cv ();
require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
	'all' => [ grep { /^cv/ } keys %Cv::Subdiv2D:: ],
	# 'all' => [ grep { /^cv/ } keys %Cv:: ],
	);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( );

our $VERSION = '0.26';

require XSLoader;
XSLoader::load('Cv::Subdiv2D', $VERSION);

*AUTOLOAD = \&Cv::autoload;

# ============================================================
#  imgproc. Image Processing: Planar Subdivisions
# ============================================================

=head1 DESCRIPTION

=head2 METHOD

=over

=item edges

=cut

sub DESTROY { }

=item CalcVoronoi, CalcSubdivVoronoi2D (legacy)

=cut

sub CalcVoronoi { goto &CalcSubdivVoronoi2D }
# sub CalcSubdivVoronoi2D { goto &cvCalcSubdivVoronoi2D }

=item ClearVoronoi, ClearSubdivVoronoi2D (legacy)

=cut

sub ClearVoronoi { goto &ClearSubdivVoronoi2D }
# sub ClearSubdivVoronoi2D { goto &cvClearSubdivVoronoi2D }

=item CreateDelaunay, CreateSubdivDelaunay2D (legacy)

=cut

sub Cv::CreateDelaunay { goto &CreateDelaunay }
sub CreateDelaunay { goto &CreateSubdivDelaunay2D }
sub CreateSubdivDelaunay2D {
	my $self = ref $_[0] || shift;
	goto &cvCreateSubdivDelaunay2D;
}


=item Locate, Subdiv2DLocate (legacy)

=cut

sub Locate { goto &Subdiv2DLocate }
# sub Subdiv2DLocate { goto &cvSubdiv2DLocate }

=item DelaunayInsert, SubdivDelaunay2DInsert (legacy)

=cut

sub DelaunayInsert { goto &SubdivDelaunay2DInsert }
# sub SubdivDelaunay2DInsert { goto &cvSubdivDelaunay2DInsert }

=item CalcSubdivVoronoi2D (legacy)

=cut

# sub CalcSubdivVoronoi2D { goto &cvCalcSubdivVoronoi2D }


=item FindNearestPoint2D (legacy)

=cut

# sub FindNearestPoint2D { goto &cvFindNearestPoint2D }

=item Subdiv2DEdgeDst (legacy)

=cut

# sub Subdiv2DEdgeDst { goto &cvSubdiv2DEdgeDst }

=item Subdiv2DEdgeOrg (legacy)

=cut

# sub Subdiv2DEdgeOrg { goto &cvSubdiv2DEdgeOrg }

=item Subdiv2DGetEdge (legacy)

=cut

# sub Subdiv2DGetEdge { goto &cvSubdiv2DGetEdge }


=item Subdiv2DNextEdge (legacy)

=cut

# sub Subdiv2DNextEdge { goto &cvSubdiv2DNextEdge }

=item Subdiv2DRotateEdge (legacy)

=cut

# sub Subdiv2DRotateEdge { goto &cvSubdiv2DRotateEdge }

=item cvCalcSubdivVoronoi2D

=item cvClearSubdivVoronoi2D

=item cvCreateSubdivDelaunay2D

=item cvFindNearestPoint2D

=item cvSubdiv2DEdgeDst

=item cvSubdiv2DEdgeOrg

=item cvSubdiv2DGetEdge

=item cvSubdiv2DLocate

=item cvSubdiv2DNextEdge

=item cvSubdiv2DRotateEdge

=item cvSubdivDelaunay2DInsert

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
