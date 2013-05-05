# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
#use Test::More qw(no_plan);
use Test::More tests => 137;
use Test::Exception;
use Cv;
BEGIN { use_ok('Cv::Histogram') }
use Data::Dumper;

# ============================================================
#  CvHistogram* cvCreateHist()
# ============================================================

can_ok('Cv::Histogram', 'cvCreateHist');
if (1) {
	my $hist = Cv::Histogram::cvCreateHist([256], CV_HIST_ARRAY);
	isa_ok($hist, 'Cv::Histogram');
	ok(scalar grep /cvCreateHist/, @Cv::Histogram::EXPORT_OK);
}

can_ok('Cv', 'cvCreateHist');
if (1) {
	my $hist = Cv::cvCreateHist([256], CV_HIST_ARRAY);
	isa_ok($hist, 'Cv::Histogram');
	ok(scalar grep /cvCreateHist/, @Cv::EXPORT_OK);
}

can_ok('Cv', 'CreateHist');
if (1) {
	my $hist = Cv->CreateHist([256], CV_HIST_ARRAY);
	isa_ok($hist, 'Cv::Histogram');
}

can_ok('Cv::Histogram', 'new');
if (1) {
	my $hist = Cv::Histogram->new([256], CV_HIST_ARRAY);
	isa_ok($hist, 'Cv::Histogram');
}

can_ok(__PACKAGE__, 'cvCreateHist');


# ============================================================
#  CvHistogram* cvCreateHist(sizes, type, ranges, uniform)
# ============================================================

# ranges=no, uniform=yes
if (1) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist(my $sizes = [256], $type);
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
		no warnings 'redefine';
		local *Cv::Histogram::cvCreateHist = sub {
			is_deeply($_[0], $sizes, 'sizes');
			is($_[1], $type, 'type');
			ok(Cv::is_null($_[2]), 'ranges');
			is($_[3], 1, 'uniform');
		};
		$hist->new();
	}
}

# ranges=yes, uniform=yes
if (2) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist(my $sizes = [256], $type, [[0, 256]]);
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
		no warnings 'redefine';
		local *Cv::Histogram::cvCreateHist = sub {
			is_deeply($_[0], $sizes, 'sizes');
			is($_[1], $type, 'type');
			is_deeply($_[2], $hist->ranges, 'ranges');
			is($_[3], 1, 'uniform');
		};
		$hist->new();
	}
}

# ranges=no, uniform=no
if (3) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
		my $hist = Cv->CreateHist(my $sizes = [1], $type, \0, 0);
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
		no warnings 'redefine';
		local *Cv::Histogram::cvCreateHist = sub {
			is_deeply($_[0], $sizes, 'sizes');
			is($_[1], $type, 'type');
			ok(Cv::is_null($_[2]), 'ranges');
			is($_[3], 0, 'uniform');
		};
		$hist->new();
	}
}

# ranges=yes, uniform=no
if (4) {
	for my $type (CV_HIST_ARRAY, CV_HIST_SPARSE) {
	  SKIP: {
		  skip "OpenCV 2.2 && CV_HIST_SPARSE", 12
			  if cvVersion() <= 2.002;# && $type == CV_HIST_SPARSE;
		  my $hist = Cv->CreateHist(my $sizes = [1], $type, [[0, 256]], 0);
		  isa_ok($hist, 'Cv::Histogram');
		  is(($hist->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		  if ($type == CV_HIST_ARRAY) {
			  isa_ok($hist->bins, 'Cv::Mat');
		  } else {
			  isa_ok($hist->bins, 'Cv::SparseMat');
		  }
		  ok(!($hist->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		  my $hist2 = $hist->new();
		  isa_ok($hist2, 'Cv::Histogram');
		  is(($hist2->type & CV_MAGIC_MASK), CV_HIST_MAGIC_VAL, 'HIST_MAGIC' );
		  isa_ok($hist2->bins, 'Cv::Mat');
		  ok(!($hist2->type & CV_HIST_UNIFORM_FLAG), 'UNIFORM_FLAG' );
		  no warnings 'redefine';
		  local *Cv::Histogram::cvCreateHist = sub {
			  is_deeply($_[0], $sizes, 'sizes');
			  is($_[1], $type, 'type');
			  is_deeply($_[2], $hist->ranges, 'ranges');
			  is($_[3], 0, 'uniform');
		  };
		  $hist->new();
		}; # SKIP
	}
}



# ============================================================
#  cvCalcHist cvCalcProbDensity cvClearHist cvCompareHist cvCopyHist
#  cvGetMinMaxHistValue cvNormalizeHist SetHistBinRanges cvThreshHist
# ============================================================

if (1) {
	my %args = (
		cvCalcHist => [ 1, 2 ],
		cvCopyHist => [ Cv->CreateHist([256], CV_HIST_ARRAY) ],
		);
	my %short = (
		cvGetMinMaxHistValue => [qw(MinMaxLoc)],
		SetHistBinRanges => [qw(SetRanges)],
		);
	for (qw(cvCalcHist cvCalcProbDensity cvClearHist cvCompareHist cvCopyHist cvGetMinMaxHistValue cvNormalizeHist SetHistBinRanges cvThreshHist)) {
		package Cv::Histogram;
		no strict 'refs';
		no warnings 'redefine';
		my $pass = 0;
		local *$_ = sub { $pass++ };
		(my $short1 = $_) =~ s/^cv//;
		my @args = @{$args{$_} || []};
		&$short1(@args);
		main::is($pass, 1, "$short1: alias of $_");
		(my $short2 = $_) =~ s/^cv|Hist//g;
		if ($short1 ne $short2 && Cv::Histogram->can($short2)) {
			$pass = 0;
			&$short2(@args);
			main::is($pass, 1, "$short2: alias of $_");
		}
		for my $short3 (@{$short{$_} || []}) {
			$pass = 0;
			&$short3(@args);
			main::is($pass, 1, "$short3: alias of $_");
		}
	}
}
