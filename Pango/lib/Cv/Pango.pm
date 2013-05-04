# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Pango;

use 5.008008;
use strict;
use warnings;
use Carp;
use Pango;
use Cv 0.26;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.26';

{
	package Cv::Arr;
	no warnings 'redefine';

	sub putText { goto \&PutText }

	sub PutText {
		my ($img, $text, $org, $font, $color) = @_;
		goto \&cvPutText if ref $font && $font->isa('Cv::Font');
		my $oimg = $img;
		if ($oimg->type == Cv::CV_8UC3) {
			my ($b, $g, $r) = $oimg->split;
			$img = Cv->merge([$b, $g, $r, $b->new->zero]);
		}
		my $type = $img->type;
		my $cairo_format; # argb32, rgb24, a8, a1, rgb16-565 
		$cairo_format = 'a8'     if $type == Cv::CV_8UC1;
		# $cairo_format = 'rgb24'  if $type == Cv::CV_8UC3;
		$cairo_format = 'argb32' if $type == Cv::CV_8UC4;
		goto \&cvPutText unless $cairo_format;
		$img->getRawData(my $data, my $step, my $size);
		my $surface = Cairo::ImageSurface->create_for_data(
			$data, $cairo_format, @$size, $step);
		my $cr = Cairo::Context->create($surface);
		my $layout = Pango::Cairo::create_layout($cr);
		$font = Pango::FontDescription->from_string($font)
			unless ref $font;
		$layout->set_font_description($font);
		$cr->move_to($org->[0], $org->[1]);
		$layout->set_text($text);
		my $line = $layout->get_line(0);
		Pango::Cairo::layout_line_path($cr, $line);
		my @color = map { $_ / 255 } @$color;
		push(@color, (0) x (3 - @color)) if @color < 3;
		my ($b, $g, $r, $a) = @color;
		$cr->set_source_rgba($r, $g, $b, 1);
		$cr->fill_preserve;
		# $cr->stroke;
		if ($oimg->type == Cv::CV_8UC3) {
			my ($b, $g, $r, $a) = $img->split;
			Cv->merge([$b, $g, $r])->copy($oimg);
		}
		$oimg;
	}

	sub boxText { goto \&BoxText }

	sub BoxText {
		my ($img, $text, $org, $font, $color) = @_;
		$font = Pango::FontDescription->from_string($font)
			unless ref $font;
		Cv->GetTextSize($text, $font, my $sz, my $b);

		# A ---- D
		# |      |
		# M ---- N
		# |      |
		# B ---- C

		my @M = @$org;
		my @N = ($M[0] + $sz->[0], $M[1]);
		my @A = ($M[0], $M[1] - $sz->[1]);
		my @B = ($M[0], $M[1] + $b);
		my @C = ($N[0], $B[1]);
		my @D = ($N[0], $A[1]);

		$img->polyLine([ [\@A, \@B, \@C, \@D, \@A],
						 [\@M, \@N]
					   ], 0, $color, 1);
	}
}

{
	package Cv;
	no warnings 'redefine';

	sub GetTextSize {
		shift if ($_[0] eq __PACKAGE__ && @_ == 5);
		Usage("textString, font, textSize, baseline") unless @_ == 4;
		if (ref $_[1] eq 'Cv::Font') {
			goto \&cvGetTextSize;
		} elsif (ref $_[1] eq 'Pango::FontDescription') {
			my $text = shift;
			my $font = shift;
			my $PANGO_SCALE = 1024; # see pango-1.0/pango/pango-types.h
			my $surface = Cairo::ImageSurface->create('a8', 16, 16);
			my $cr = Cairo::Context->create($surface);
			my $layout = Pango::Cairo::create_layout($cr);
			$layout->set_font_description($font);
			$layout->set_text($text);
			Pango::Cairo::layout_path($cr, $layout);
			my ($w, $hh, $bb) = map { $_ / $PANGO_SCALE } (
				$layout->get_size(),
				$layout->get_baseline()
			);
			my ($h, $b) = ($bb, -$bb + $hh);
			if (@_ >= 1) {
				$_[0] = [] unless ref $_[0] eq 'ARRAY';
				@{$_[0]} = ($w, $h);
			}
			if (@_ >= 2) {
				$_[1] = $b;
			}
		} else {
			Carp::croak "unknown font @{[ ref $_[1] ]} in Cv::GetTextSize";
		}
	}
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=encoding utf8

=head1 NAME

Cv::Pango - Draw a variety of characters using the Pango

=head1 SYNOPSIS

 use Cv;
 use Cv::Pango;
 
 my $img = Cv::Mat->new([240, 320], CV_8UC4);
 $img->putText(
	"\x{03A0}\x{03B1}\x{03BD}\x{8A9E}", # "Παν語",
	[20, 200], 'Sans Serif 42',
	);
 $img->showImage;
 $img->waitKey;

=head1 DESCRIPTION

C<Cv::Pango> draw a variety of characters by using Pango.
Replace C<Cv::Arr::PutText()> itself.

=head2 BUGS

=over

=item *

=back

=head1 SEE ALSO

C<Cv>, C<Pango>

=head1 AUTHOR

MASUDA Yuta E<lt>yuta.cpan@gmail.comE<gt>

=head1 LICENCE

Copyright (c) 2013 by Masuda Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
