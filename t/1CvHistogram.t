# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More;
use Test::Exception;
BEGIN {
	eval { use Cv -nomore };
	eval { require XSLoader; XSLoader::load('Cv::Test', $Cv::VERSION) };
	plan skip_all => "no Cv/Test.so" if $@;
	plan tests => 80;
}

# ranges=no, uniform=yes
if (1) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist([256], $type);
		isa_ok($hist, 'Cv::Histogram');
		is(($hist->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		if ($type == CV_HIST_ARRAY) {
			isa_ok($hist->bins, 'Cv::Mat');
		} else {
			isa_ok($hist->bins, 'Cv::SparseMat');
		}
		ok( ($hist->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok(!($hist->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
		my $hist2 = $hist->new();
		isa_ok($hist2, 'Cv::Histogram');
		is(($hist2->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		isa_ok($hist2->bins, 'Cv::Mat');
		ok( ($hist2->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok(!($hist2->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
	}
}

# ranges=yes, uniform=yes
if (2) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist([256], $type, [[0, 256]]);
		isa_ok($hist, 'Cv::Histogram');
		is(($hist->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		if ($type == CV_HIST_ARRAY) {
			isa_ok($hist->bins, 'Cv::Mat');
		} else {
			isa_ok($hist->bins, 'Cv::SparseMat');
		}
		ok(($hist->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok(($hist->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
		my $hist2 = $hist->new();
		isa_ok($hist2, 'Cv::Histogram');
		is(($hist2->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		isa_ok($hist2->bins, 'Cv::Mat');
		ok(($hist2->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok(($hist2->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
	}
}

# ranges=no, uniform=no
if (3) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist([1], $type, \0, 0);
		isa_ok($hist, 'Cv::Histogram');
		is(($hist->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		if ($type == CV_HIST_ARRAY) {
			isa_ok($hist->bins, 'Cv::Mat');
		} else {
			isa_ok($hist->bins, 'Cv::SparseMat');
		}
		ok(!($hist->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok(!($hist->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
		my $hist2 = $hist->new();
		isa_ok($hist2, 'Cv::Histogram');
		is(($hist2->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		isa_ok($hist2->bins, 'Cv::Mat');
		ok(!($hist2->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok(!($hist2->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
	}
}

# ranges=yes, uniform=no
if (4) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist([1], $type, [[0, 256]], 0);
		isa_ok($hist, 'Cv::Histogram');
		is(($hist->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		if ($type == CV_HIST_ARRAY) {
			isa_ok($hist->bins, 'Cv::Mat');
		} else {
			isa_ok($hist->bins, 'Cv::SparseMat');
		}
		ok(!($hist->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok( ($hist->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
		my $hist2 = $hist->new();
		isa_ok($hist2, 'Cv::Histogram');
		is(($hist2->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		isa_ok($hist2->bins, 'Cv::Mat');
		ok(!($hist2->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		ok( ($hist2->type & CV_HIST_RANGES_FLAG ), 'RANGES_FLAG'  );
	}
}
