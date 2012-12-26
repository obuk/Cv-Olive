# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 6;
BEGIN {
	use_ok('Cv', qw(:nomore /^cv/));
}

sub err_is {
	our $line;
	my $m = shift;
	chomp(my $e = $@);
	$e =~ s/\.$//;
	unshift(@_, $e, "$m at $0 line $line");
	goto &is;
}

our $line;
$line = __LINE__; eval { cvCreateImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

$line = __LINE__; eval { Cv->createImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

$line = __LINE__; eval { Cv->createImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

$line = __LINE__; eval { Cv->CreateImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

$line = __LINE__; eval { Cv->CreateImage() };
err_is("Usage: Cv::cvCreateImage(size, depth, channels)");

$line = __LINE__; eval { my $scalar = Cv->createMat() };
err_is("Usage: Cv::cvCreateMat(rows, cols, type)");

TODO: {
	local $TODO = "fix error location in list context";
	$line = __LINE__; eval { my @list = Cv->createMatND() };
	err_is("Usage: Cv::cvCreateMatND(sizes, type)");
}
