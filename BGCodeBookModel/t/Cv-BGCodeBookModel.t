# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 19;
use Test::Exception;
BEGIN { use_ok('Cv', -bg) }

# ============================================================
#  CvBGCodeBookModel* cvCreateBGCodeBookModel
# ============================================================

can_ok('Cv::BGCodeBookModel', 'cvCreateBGCodeBookModel');
if (1) {
	my $model = Cv::BGCodeBookModel::cvCreateBGCodeBookModel();
	isa_ok($model, 'Cv::BGCodeBookModel');
	ok(scalar grep /cvCreateBGCodeBookModel/, @Cv::BGCodeBookModel::EXPORT_OK);
}

can_ok('Cv', 'cvCreateBGCodeBookModel');
if (1) {
	my $model = Cv::cvCreateBGCodeBookModel();
	isa_ok($model, 'Cv::BGCodeBookModel');
	ok(scalar grep /cvCreateBGCodeBookModel/, @Cv::EXPORT_OK);
}

can_ok('Cv', 'CreateBGCodeBookModel');
if (1) {
	my $model = Cv->CreateBGCodeBookModel();
	isa_ok($model, 'Cv::BGCodeBookModel');
}

can_ok('Cv::BGCodeBookModel', 'new');
if (1) {
	my $model = Cv::BGCodeBookModel->new;
	isa_ok($model, 'Cv::BGCodeBookModel');
}

can_ok(__PACKAGE__, 'cvCreateBGCodeBookModel');


# ============================================================
#  cvBGCodeBookClearStale
# ============================================================

if (1) {
	my $model = 'Cv::BGCodeBookModel';
	my $pass = 0;
	no warnings 'redefine';
	local *Cv::BGCodeBookModel::cvBGCodeBookClearStale = sub { $pass++ };
	$model->BGCodeBookClearStale();
	$model->ClearStale();
	is($pass, 2, 'alias of cvBGCodeBookClearStale');
}


# ============================================================
#  cvBGCodeBookDiff
# ============================================================

if (1) {
	my $model = 'Cv::BGCodeBookModel';
	my $pass = 0;
	no warnings 'redefine';
	local *Cv::BGCodeBookModel::cvBGCodeBookDiff = sub { $pass++ };
	$model->BGCodeBookDiff();
	$model->Diff();
	is($pass, 2, 'alias of cvBGCodeBookDiff');
}

# ============================================================
#  cvBGCodeBookUpdate
# ============================================================

if (1) {
	my $model = 'Cv::BGCodeBookModel';
	my $pass = 0;
	no warnings 'redefine';
	local *Cv::BGCodeBookModel::cvBGCodeBookUpdate = sub { $pass++ };
	$model->BGCodeBookUpdate();
	$model->Update();
	is($pass, 2, 'alias of cvBGCodeBookUpdate');
}

# ============================================================
#  cvSegmentFGMask
# ============================================================

if (1) {
	my $model = 'Cv::BGCodeBookModel';
	my $pass = 0;
	no warnings 'redefine';
	local *Cv::BGCodeBookModel::cvSegmentFGMask = sub { $pass++ };
	$model->SegmentFGMask();
	is($pass, 1, 'alias of cvSegmentFGMask');
}

# ============================================================
#  AV* modMin(CvBGCodeBookModel* model, AV* value = NO_INIT)
#  AV* modMax(CvBGCodeBookModel* model, AV* value = NO_INIT)
#  AV* cbBounds(CvBGCodeBookModel* model, AV* value = NO_INIT)
#  int t(CvBGCodeBookModel* model)
# ============================================================

if (1) {
	my $model = Cv::BGCodeBookModel->new;
	$model->modMin(my $min = [ map { int rand 256 } 1, 2, 3 ]);
	is_deeply($model->modMin, $min);
	$model->modMax(my $max = [ map { int rand 256 } 1, 2, 3 ]);
	is_deeply($model->modMax, $max);
	$model->cbBounds(my $bounds = [ map { int rand 256 } 1, 2, 3 ]);
	is_deeply($model->cbBounds, $bounds);
	$model->can('t');
}
