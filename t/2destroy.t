# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More (tests => 4);
use Test::More qw(no_plan);
use Test::Exception;
BEGIN { use_ok('Cv', -nomore) }

if (1) {
	my $mat = Cv::Image->new([10, 10], CV_8UC3);
	my $ref = \$mat;
	lives_ok { $mat->DESTROY };
	lives_ok { $mat->DESTROY };
}

if (1) {
	my $mat = Cv::Mat->new([10, 10], CV_32FC1);
	my $ref = \$mat;
	lives_ok { $mat->DESTROY };
	lives_ok { $mat->DESTROY };
}

if (1) {
	my $mat = Cv::MatND->new([10, 10], CV_32FC1);
	my $ref = \$mat;
	lives_ok { $mat->DESTROY };
	lives_ok { $mat->DESTROY };
}

if (1) {
	my $mat = Cv::SparseMat->new([10, 10], CV_32FC1);
	my $ref = \$mat;
	lives_ok { $mat->DESTROY };
	lives_ok { $mat->DESTROY };
}
