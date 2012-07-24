# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

# ============================================================
#  cvMatchTemplate(image, templ, [result], method)
#  (1) $image->MatchTemplate($templ, CV_TM_SQDIFF);
#  (2) $image->MatchTemplate($templ, $result, CV_TM_SQDIFF);
# ============================================================

SKIP: {
	skip('can not run with 2.3.3', 1) if Cv->version == 2.003003;

if (1) {
	my $rows = 240;
	my $cols = 320;
	my $image = Cv->CreateMat($rows, $cols, CV_8UC1);
	my $templ = Cv->CreateMat($rows/10, $cols/10, CV_8UC1);
	my $result = $image->matchTemplate($templ, CV_TM_SQDIFF);
	is($result->rows, $image->rows - $templ->rows + 1);
	is($result->cols, $image->cols - $templ->cols + 1);
	is($result->type, CV_32FC1);
}

if (0*2) {
	my $rows = 240;
	my $cols = 320;
	my $image = Cv->CreateMat($rows, $cols, CV_8UC1);
	my $templ = Cv->CreateMat($rows/10, $cols/10, CV_8UC1);
	my $result = Cv->CreateMat($image->rows - $templ->rows + 1,
							   $image->cols - $templ->cols + 1,
							   CV_32FC1);
	my $dst = $image->matchTemplate($templ, $result, CV_TM_SQDIFF);
	is($dst, $result);
}

}
