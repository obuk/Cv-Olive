# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More;
use Test::Exception;
use Cv;

eval "use Cv::Qt qw(:all)";
plan skip_all => "Qt required" unless !$@ && cvHasQt();
plan tests => 8;

# ============================================================
#  CvFont cvFontQt(
#     char* nameFont, int pointSize = -1, CvScalar color = cvScalarAll(0),
#     int weight = CV_FONT_NORMAL, int style = CV_STYLE_NORMAL,
#     int spacing = 0)
# ============================================================

throws_ok { cvFontQt() }
qr/Usage: Cv::Qt::cvFontQt\(nameFont, pointSize= -1, color= cvScalarAll\(0\), weight= CV_FONT_NORMAL, style= CV_STYLE_NORMAL, spacing= 0\)/;

my $huge = cvFontQt('Helvetica', 20);
isa_ok($huge, 'Cv::Font');

my $bold = cvFontQt('Times', 10, cvScalarAll(0), eval "&CV_FONT_BOLD");
isa_ok($bold, 'Cv::Font');

my $normal = Cv->FontQt('Times', 10, cvScalarAll(0), eval "&CV_FONT_NORMAL");
isa_ok($normal, 'Cv::Font');

# ============================================================
#  void cvAddText(CvArr* img, char* text, CvPoint location, CvFont *font)
# ============================================================

SKIP: {
	skip "cvAddText() unless DISPLAY", 4 unless Cv->hasGUI;

	Cv->namedWindow('Cv', CV_WINDOW_AUTOSIZE);

	my $img = Cv->createImage([480, 240], 8, 3);
	$img->fill(cvScalarAll(255));

	throws_ok { cvAddText() }
	qr/Usage: Cv::Qt::cvAddText\(img, text, location, font\)/;

	lives_ok { cvAddText($img, "Hello, Qt", [ 10, 80 ], $huge) };
	my $text = "The quick brown fox jumps over the lazy dog. 01234567890";
	if ($normal) {
		lives_ok { cvAddText($img, $text, [ 10, 100 ], $normal) };
	}
	if ($bold) {
		lives_ok { $img->AddText($text, [ 10, 120 ], $bold) };
	}

	$img->show('Cv');
	Cv->waitKey(1000);
}
