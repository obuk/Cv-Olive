# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::Histogram - Perl extension for OpenCV Histogram

=head1 SYNOPSIS

 use Cv::Histogram;

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

=head1 DESCRIPTION

=head2 METHOD

=over

=item new (cvCreateHist)

 $hist = Cv::Histogram->new($sizes, $type, $ranges, $uniform);
 $hist = Cv::Histogram->new($sizes, $type);
 $hist2 = $hist1->new;

=item bins, ranges, sizes, type (members of CvHistogram)

 $hist->bins
 $hist->type
 $hist->ranges
 $hist->uniform

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


=item DESTROY (cvReleaseHist)

=cut

sub DESTROY { goto &cvReleaseHist }


=item GetHistValue, Get

 $value = $hist->get($idx0);
 $value = $hist->get($idx0, $idx1);
 $value = $hist->get($idx0, $idx1, $idx2);
 $value = $hist->get(\@idx);

=cut

sub Get { goto &GetHistValue }
sub GetHistValue {
	my $self = shift;
	my $arr = $self->bins->Ptr(@_);
	my @floats = unpack("f*", $arr); # XXXXX
	wantarray? @floats : \@floats;
}


=item QueryHistValue, Query

 $value = $hist->query($idx0);
 $value = $hist->query($idx0, $idx1);
 $value = $hist->query($idx0, $idx1, $idx2);
 $value = $hist->query(\@idx);

=cut

sub Query { goto &QueryHistValue }
sub QueryHistValue {
	my $self = shift;
	$self->bins->GetReal(@_);
}

=item CalcBackProject

 $hist->CalcBackProject(\@image, $back_project);

=cut

sub CalcBackProject {
	Cv::Usage("hist, images, back_project") unless @_ == 3;
	my ($hist, $images, $back_project) = splice(@_, 0, 3);
	unshift(@_, $images, $back_project, $hist);
	goto &cvCalcBackProject;
}

=item CalcBackProjectPatch

 $hist->CalcBackProjectPatch(\@image, $dst, $patch_size, $method, $factor);

=cut

sub CalcBackProjectPatch {
	Cv::Usage("hist, images, dst, patch_size, method, factor") unless @_ == 6;
	my ($hist, $images, $dst, $patch_size) = splice(@_, 0, 4);
	unshift(@_, $images, $dst, $patch_size, $hist);
	goto &cvCalcBackProjectPatch;
}


=item CalcHist, Calc

 $hist->calc(\@image, $accumulate, $mask);
 $hist->calc(\@image);

=cut

sub Calc { goto &CalcHist }
sub CalcHist {
	Cv::Usage("hist, image, accumulate=0, mask=NULL") unless 2 <= @_ && @_ <= 4;
	my ($hist, $image) = splice(@_, 0, 2);
	unshift(@_, $image, $hist);
	goto &cvCalcHist
}


=item CalcProbDensity

 $hist1->CalcProbDensity($hist2, $dst_hist, $scale);
 $hist1->CalcProbDensity($hist2, $dst_hist);

=cut

sub CalcProbDensity { goto &cvCalcProbDensity }

=item ClearHist, Clear

 $hist->clear;

=cut

sub Clear { goto &ClearHist }
sub ClearHist { goto &cvClearHist }

=item CompareHist, Compare

 $hist1->compare($hist2, $method);

=cut

sub Compare { goto &CompareHist }
sub CompareHist { goto &cvCompareHist }


=item CopyHist, Copy

 $src->copy($dst);
 $dst = $src->copy;

=cut

sub Copy { goto &CopyHist }
sub CopyHist {
	$_[1] ||= $_[0]->new;
	goto &cvCopyHist;
}


=item GetMinMaxHistValue, MinMaxLoc

 $hist->minMaxLoc(my $min_value, my $max_value, my $min_idx, my $max_idx);
 $hist->minMaxLoc(my $min_value, my $max_value);

=cut

sub MinMaxLoc { goto &GetMinMaxHistValue }
sub GetMinMaxHistValue {
	$_[3] = my $min_idx unless defined $_[3];
	$_[4] = my $max_idx unless defined $_[4];
	goto &cvGetMinMaxHistValue;
}

=item NormalizeHist, Normalize

 $hist->normalize($factor);

=cut

sub Normalize { goto &NormalizeHist }
sub NormalizeHist { goto &cvNormalizeHist }

=item SetHistBinRanges, SetRanges

 $hist->setRanges(\@ranges, $uniform);
 $hist->setRanges(\@ranges);

=cut

sub SetRanges { goto &SetHistBinRanges }
sub SetHistBinRanges { goto &cvSetHistBinRanges }

=item ThreshHist, Thresh

 $hist->thresh($threshold);

=cut

sub Thresh { goto &ThreshHist }
sub ThreshHist { goto &cvThreshHist }


=item CalcPGH

 $hist->calcPGH($contour);

=cut

sub Cv::Arr::CalcPGH { goto &cvCalcPGH }

sub CalcPGH {
	Cv::Usage("hist, contour") unless @_ == 2;
	my ($hist, $contour) = splice(@_, 0, 2);
	unshift(@_, $contour, $hist);
	goto &cvCalcPGH;
}

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
