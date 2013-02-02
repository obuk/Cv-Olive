# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 35;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }

use Data::Dumper;

sub D (\@) {
	Data::Dumper->Dump([@{$_[0]}], [map { "\$_[$_]" } 0 .. $#{$_[0]}]);
}

if (1) {
	my $e = "error";
	$@ = $e;
	is(Cv::cvErrorStr(-2), "Unspecified error");
	is($@, $e);
	is(Cv->ErrorStr(-2), "Unspecified error");
	is($@, $e);
	is(Cv->errorStr(-2), "Unspecified error");
	is($@, $e);
}

if (2) {
	my ($status, $funcName, $errMsg);
	eval {
		_e; Cv->error(
			$status = -1,
			$funcName = "funcName",
			$errMsg = "errMsg",
			);
	};
	err_is(join(' ', "OpenCV Error:", Cv->errorStr($status),
				"($errMsg)", "in $funcName"));
}

if (3) {
	Cv->setErrMode(0);
	is(Cv->getErrMode(), 0, "errMode");
	my ($status, $funcName, $errMsg, $file, $line);
	my $err;
	sub myError {
		$err = \@_;
		# print STDERR "myerror:\n", D(@_);
	}
	my $prevError = Cv->redirectError(
		\&myError, my $myData = "mydata",
		my $prevData,
		);
	eval {
		_e; Cv->error(
			$status = -1,
			$funcName = "funcName",
			$errMsg = "errMsg0",
			$file = rand,
			$line = rand,
			);
	};
	err_is("OpenCV Error: Backtrace ($errMsg) in $funcName");
	is(Cv->getErrStatus(), $status, "errStatus");
	is($err->[0], $status);
	is($err->[1], $funcName);
	is($err->[2], $errMsg);
	is($err->[3], $file);
	is($err->[4], $line);
	is($err->[5], $myData);
	my $prevError2 = Cv->redirectError($prevError, $prevData, my $prevData2);
	is($prevError2, \&myError);
	is($prevData2, $myData);
}

if (4) {
	Cv->setErrMode(1);
	is(Cv->getErrMode(), 1, "errMode1");
	my ($status, $funcName, $errMsg, $file, $line);
	my $err;
	my $prevError = Cv->redirectError(
		my $myError = sub {
			$err = \@_;
			# print STDERR "myerror1:\n", D(@_);
		},
		my $myData = "mydata1",
		my $prevData,
		);
	eval {
		_e; Cv->error(
			$status = -2,
			$funcName = "funcName1",
			$errMsg = "errMsg1",
			$file = rand,
			$line = rand,
			);
	};
	is($@, '');
	is(Cv->getErrStatus(), $status, "errStatus");
	is($err->[0], $status);
	is($err->[1], $funcName);
	is($err->[2], $errMsg);
	is($err->[3], $file);
	is($err->[4], $line);
	is($err->[5], $myData);
	my $prevError2 = Cv->redirectError($prevError, $prevData, my $prevData2);
	is($prevError2, $myError);
	is($prevData2, $myData);
}

if (5) {
	Cv->setErrMode(2);
	is(Cv->getErrMode(), 2, "errMode2");
	my ($status, $funcName, $errMsg, $file, $line);
	my $err;
	my $prevError = Cv->redirectError(
		sub {
			$err = \@_;
			# print STDERR "myerror1:\n", D(@_);
		},
		my $myData = "mydata2",
		my $prevData,
		);
	eval {
		_e; Cv->error(
			$status = -3,
			$funcName = "funcName2",
			$errMsg = "errMsg2",
			$file = rand,
			$line = rand,
			);
	};
	is($@, '');
	is(Cv->getErrStatus(), $status, "errStatus");
	is($err, undef);
	Cv->redirectError($prevError, $prevData);
}

if (6) {
	Cv->setErrMode(0);
	Cv->redirectError(sub { });
	e { Cv::cvCreateImage([-1, -1], 8, 3); };
	err_is("OpenCV Error: Unknown error code -25 (Bad input roi) in cvInitImageHeader");
}
