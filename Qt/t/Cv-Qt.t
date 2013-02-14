# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More;
BEGIN { use_ok('Cv::Test') }
BEGIN { use_ok('Cv') }
eval "use Cv::Qt qw(:all)";
plan skip_all => "Qt required for testing" unless !$@ && cvHasQt();

# ============================================================
#  CvFont cvFontQt(
#     char* nameFont, int pointSize = -1, CvScalar color = cvScalarAll(0),
#     int weight = CV_FONT_NORMAL, int style = CV_STYLE_NORMAL,
#     int spacing = 0)
# ============================================================

e { cvFontQt() };
err_is('Usage: Cv::Qt::cvFontQt(nameFont, pointSize= -1, color= cvScalarAll(0), weight= CV_FONT_NORMAL, style= CV_STYLE_NORMAL, spacing= 0)');

my $huge = e { cvFontQt('Helvetica', 20) };
isa_ok($huge, 'Cv::Font');

my $bold = e { cvFontQt('Times', 10, cvScalarAll(0),
						eval "&CV_FONT_BOLD") };
isa_ok($bold, 'Cv::Font');

my $normal = e { Cv->FontQt('Times', 10, cvScalarAll(0),
							eval "&CV_FONT_NORMAL") };
isa_ok($normal, 'Cv::Font');

# ============================================================
#  void cvAddText(CvArr* img, char* text, CvPoint location, CvFont *font)
# ============================================================

SKIP: {
	skip "cvAddText() unless DISPLAY", 4 unless Cv->hasGUI;

	Cv->namedWindow('Cv', CV_WINDOW_AUTOSIZE);

	my $img = Cv->createImage([480, 240], 8, 3);
	$img->fill(cvScalarAll(255));

	e { cvAddText() };
	err_is('Usage: Cv::Qt::cvAddText(img, text, location, font)');

	e { cvAddText($img, "Hello, Qt", [ 10, 80 ], $huge) }; err_is('');
	my $text = "The quick brown fox jumps over the lazy dog. 01234567890";
	if ($normal) {
		e { cvAddText($img, $text, [ 10, 100 ], $normal) };
		err_is('');
	}
	if ($bold) {
		e { $img->AddText($text, [ 10, 120 ], $bold) };
		err_is('');
	}

	$img->show('Cv');
	Cv->waitKey(1000);
}

plan tests => 10;
