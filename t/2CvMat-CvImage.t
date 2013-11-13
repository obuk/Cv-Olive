# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 2;
BEGIN { use_ok('Cv', -nomore) }

SKIP: {
	skip "Test::Exception required", 1 unless eval "use Test::Exception";

	my $mat = Cv::Mat->new([240, 320], CV_8UC1);
	lives_ok { $mat->Cv::Image::new };
}
