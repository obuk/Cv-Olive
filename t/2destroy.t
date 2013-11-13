# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 9;
BEGIN { use_ok('Cv', -nomore) }

SKIP: {
	skip "Test::Exception required", 8 unless eval "use Test::Exception";

	{
		my $mat = Cv::Image->new([10, 10], CV_8UC3);
		my $ref = \$mat;
		lives_ok { $mat->DESTROY };
		lives_ok { $mat->DESTROY };
	}

	{
		my $mat = Cv::Mat->new([10, 10], CV_32FC1);
		my $ref = \$mat;
		lives_ok { $mat->DESTROY };
		lives_ok { $mat->DESTROY };
	}

	{
		my $mat = Cv::MatND->new([10, 10], CV_32FC1);
		my $ref = \$mat;
		lives_ok { $mat->DESTROY };
		lives_ok { $mat->DESTROY };
	}

	{
		my $mat = Cv::SparseMat->new([10, 10], CV_32FC1);
		my $ref = \$mat;
		lives_ok { $mat->DESTROY };
		lives_ok { $mat->DESTROY };
	}
}

