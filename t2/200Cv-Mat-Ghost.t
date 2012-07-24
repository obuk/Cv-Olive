# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

if (1) {
	no warnings;
	no strict 'refs';
	my $destroy = 0;
	# my $destroy_ghost = 0;
	local *{Cv::Mat::DESTROY} = sub { $destroy++; };
	# local *{Cv::Mat::Ghost::DESTROY} = sub { $destroy_ghost++; };
	my $mat = Cv::Mat->new([ 240, 320 ], CV_8UC1);
	isa_ok($mat, 'Cv::Mat');
	bless $mat, join('::', ref $mat, 'Ghost');
	$mat = undef;
	is($destroy, 0);
	# is($destroy_ghost, 0);
}
