# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::MSER - Cv extension for Features Detector

=head1 SYNOPSIS

  use Cv::MSER;
  my $mser = Cv->MSER();
  my $keypoints = $mser->detect($image, $mask);

=cut

package Cv::MSER;

use 5.008008;
use strict;
use warnings;
use Cv ();

our $VERSION = '0.27';

require XSLoader;
XSLoader::load('Cv::MSER', $VERSION);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = grep /^(IPL|CV|cv)/, (keys %Cv::MSER::);

our %EXPORT_TAGS = (
	'all' => \@EXPORT_OK,
	);

our @EXPORT = ( );

*AUTOLOAD = \&Cv::autoload;

# ============================================================
#  features2d. 2D Features Framework
# ============================================================

=head1 DESCRIPTION

=head2 METHOD

=over

=item MSER

  my $mser = Cv->MSER();
  my $mser = Cv->MSER(@{cvMSERParams(@$params)});
  my $mser = Cv->MSER(5, 14400, 60, ...);
  my $mser = Cv->MSER(-delta => 5, -maxArea => 14400, ...);

=item detect

  my $keypoints = $mser->detect($image, $mask);
  my $keypoints = $mser->detect($image);

=cut

our @MSER = (
	delta => 5,
	maxArea => 14400,
	minArea => 60,
	maxVariation => 0.25,
	minDiversity => 0.2,
	maxEvolution => 200,
	areaThreshold => 1.01,
	minMargin => 0.003,
	edgeBlurSize => 5,
	);

sub Cv::MSER {
	my $self = shift;
	my @template;
	for (my $i = 0; $i < @MSER; $i += 2) {
		my ($k, $v) = @MSER[$i, $i + 1];
		if (ref $self && defined $self->{$k}) {
			$v = $self->{$k};
		}
		push(@template, $k, $v);
	}
	bless Cv::named_parameter(\@template, @_);
}

sub DESTROY { }


=item cvMSERParams

  my $params = cvMSERParams(
                $delta, $minArea, $maxArea, $maxVariation, $minDiversity,
                $maxEvolution, $areaThreshold, $minMargin, $edgeBlurSize,
               );

=cut

push(@Cv::EXPORT_OK, 'cvMSERParams');
sub Cv::cvMSERParams { goto &cvMSERParams }
sub cvMSERParams {
	my $p = Cv::named_parameter(\@MSER, @_);
	my @params;
	for (my $i = 0; $i < @MSER; $i += 2) {
		push(@params, $p->{$MSER[$i]});
	}
	\@params;
}


=item cvExtractMSER()

  $img->extractMSER($mask, my $contours, $storage, $params);

=cut

sub Cv::Arr::cvExtractMSER { goto &cvExtractMSER }
sub cvExtractMSER {
	my $storage = Cv::stor(@_);
	Cv::Usage("img, mask, contours, storage, params") unless @_ == 4;
	my $params = pop;
	my $mser = Cv->MSER(@$params);
	my $keypoints = $mser->detect($_[0], $_[1]);
	$_[2] = bless Cv::cvCreateSeq(
		0, Cv::CV_SIZEOF('CvSeq'), Cv::CV_SIZEOF('CvSeq*'), $storage
		), 'Cv::Seq::Seq';
	for (@$keypoints) {
		my $pts = Cv::Seq::Point->new($storage);
		$pts->push($_) for @$_;
		$_[2]->push($pts);
	}
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

Copyright (c) 2013 by MASUDA Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
