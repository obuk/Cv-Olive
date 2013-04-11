# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::Histogram - Perl extension for OpenCV Histogram

=head1 SYNOPSIS

  use Cv::Histogram;

=head1 DESCRIPTION

=cut

package Cv::Histogram;

use 5.008008;
use strict;
use warnings;
use Cv ();
require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
	'all' => [ grep { /^cv/ } keys %Cv::Histogram:: ],
	);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( );

our $VERSION = '0.26';

require XSLoader;
XSLoader::load('Cv::Histogram', $VERSION);

*AUTOLOAD = \&Cv::autoload;

# ============================================================
#  imgproc. Image Processing: Histograms
# ============================================================

=head2 METHOD

=over

=item new($self, $sizes, $type, $ranges, $uniform)

=item cvCreateHist()

=item bins()

=item ranges() - alias of thresh

=item sizes()

=item type()

=cut

sub Cv::CreateHist { goto &new }

sub new {
	my $self = shift;
	my ($sizes, $type, $ranges, $uniform) = @_;
	if (ref $self) {
		unless (defined $sizes) {
			$sizes = $self->sizes;
		}
		unless (defined $type) {
			$type = ref $self->bins && $self->bins->isa('Cv::SparseMat')?
				&Cv::CV_HIST_SPARSE : &Cv::CV_HIST_ARRAY;
		}
		unless (defined $ranges) {
			$ranges = $self->type & &Cv::CV_HIST_RANGES_FLAG?
				$self->ranges : \0;
		}
		unless (defined $uniform) {
			$uniform = $self->type & &Cv::CV_HIST_UNIFORM_FLAG? 1 : 0
		}
	}
	Cv::Usage("sizes, type, ranges=NULL, uniform=1")
		unless defined $sizes && defined $type;
	@_ = ($sizes, $type);
	push(@_, $ranges) if defined $ranges;
	push(@_, $uniform) if defined $uniform;
	goto &cvCreateHist;
}


=item cvReleaseHist()

=cut

sub DESTROY { goto &cvReleaseHist }


=item GetHistValue()

=cut

sub GetHistValue {
	my $self = shift;
	my $arr = $self->bins->Ptr(@_);
	my @floats = unpack("f*", $arr); # XXXXX
	wantarray? @floats : \@floats;
}

=item QueryHistValue()

=cut

sub QueryHistValue {
	my $self = shift;
	$self->bins->GetReal(@_);
}

=item CalcBackProject()

=item cvCalcBackProject()

=cut

sub CalcBackProject {
	Cv::Usage("hist, images, back_project") unless @_ == 3;
	my ($hist, $images, $back_project) = splice(@_, 0, 3);
	unshift(@_, $images, $back_project, $hist);
	goto &cvCalcBackProject;
}

=item CalcBackProjectPatch()

=item cvCalcBackProjectPatch()

=cut

sub CalcBackProjectPatch {
	Cv::Usage("hist, images, dst, patch_size, method, factor") unless @_ == 6;
	my ($hist, $images, $dst, $patch_size) = splice(@_, 0, 4);
	unshift(@_, $images, $dst, $patch_size, $hist);
	goto &cvCalcBackProjectPatch;
}


=item CalcHist()

=item cvCalcHist()

=item Calc()

=cut

sub Calc { goto &CalcHist }
sub CalcHist {
	Cv::Usage("hist, image, accumulate=0, mask=NULL") unless 2 <= @_ && @_ <= 4;
	my ($hist, $image) = splice(@_, 0, 2);
	unshift(@_, $image, $hist);
	goto &cvCalcHist
}


=item CalcProbDensity()

=item cvCalcProbDensity()

=cut

sub CalcProbDensity { goto &cvCalcProbDensity }

=item ClearHist()

=item cvClearHist()

=item Clear()

=cut

sub Clear { goto &ClearHist }
sub ClearHist { goto &cvClearHist }

=item CompareHist()

=item cvCompareHist()

=item Compare()

=cut

sub Compare { goto &CompareHist }
sub CompareHist { goto &cvCompareHist }


=item CopyHist()

=item cvCopyHist()

=item Copy()

=cut

sub Copy { goto &CopyHist }
sub CopyHist {
	$_[1] ||= $_[0]->new;
	goto &cvCopyHist;
}


=item GetMinMaxHistValue()

=item cvGetMinMaxHistValue()

=cut

sub GetMinMaxHistValue {
	$_[3] = my $min_idx unless defined $_[3];
	$_[4] = my $max_idx unless defined $_[4];
	goto &cvGetMinMaxHistValue;
}

=item NormalizeHist()

=item cvNormalizeHist()

=item Normalize()

=cut

sub Normalize { goto &NormalizeHist }
sub NormalizeHist { goto &cvNormalizeHist }

=item SetHistBinRanges()

=item cvSetHistBinRanges()

=item SetBinRanges()

=cut

sub SetBinRanges { goto &SetHistBinRanges }
sub SetHistBinRanges { goto &cvSetHistBinRanges }

=item ThreshHist()

=item cvThreshHist()

=item Thresh()

=cut

sub Thresh { goto &ThreshHist }
sub ThreshHist { goto &cvThreshHist }


=item CalcPGH()

=item cvCalcPGH()

=cut

sub Cv::Arr::CalcPGH { goto &cvCalcPGH }

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
