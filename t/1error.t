# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 33;

BEGIN {
	use_ok('Cv', -more);
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


use Data::Dumper;

sub D (\@) {
	Data::Dumper->Dump(
		[@{$_[0]}],
		[map { "\$_[$_]" } 0 .. $#{$_[0]}]
		);
}

our $line;

sub err_is {
	our $line;
	chop(my $a = $@);
	my $b = shift(@_) . " at $0 line $line";
	$b .= '.' if $a =~ m/\.$/;
	unshift(@_, "$a\n", "$b\n");
	goto &is;
}

SKIP: {
	skip("can't hook error (cygwin)", 2) if $^O eq 'cygwin';

	if (1) {
		my ($status, $funcName, $errMsg, $fileName);
		eval {
			$line = __LINE__ + 1;
			Cv->error(
				$status = -1,
				$funcName = "funcName",
				$errMsg = "errMsg",
				$fileName = __FILE__,
				$line,
				);
		};
		err_is(join(' ', "OpenCV Error:", Cv->errorStr($status),
					"($errMsg)", "in $funcName"));
	}

	my $err;
	sub myerror {
		$err = \@_;
		# print STDERR "myerror:\n", D(@_);
	}

	if (1) {
		is(Cv->getErrMode(), 0, "errMode");
		my ($status, $funcName, $errMsg, $fileName, $line, $data);
		my $prevError = Cv->redirectError(
			\&myerror, $data = "mydata",
			my $prevData,
			);
		eval {
			Cv->error(
				$status = -1,
				$funcName = "funcName",
				$errMsg = "errMsg",
				$fileName = __FILE__,
				$line = __LINE__,
				);
		};
		ok($@);
		is(Cv->getErrStatus(), $status, "errStatus");
		is($err->[0], $status);
		is($err->[1], $funcName);
		is($err->[2], $errMsg);
		is($err->[3], $fileName);
		is($err->[4], $line);
		is($err->[5], $data);
	}

	if (2) {
		Cv->setErrMode(1);
		is(Cv->getErrMode(), 1, "errMode1");
		my ($status, $funcName, $errMsg, $fileName, $line, $data);
		my $err1;
		my $prevError = Cv->redirectError(
			sub {
				$err1 = \@_;
				# print STDERR "myerror1:\n", D(@_);
			},
			$data = "mydata1",
			my $prevData,
			);
		eval {
			Cv->error(
				$status = -2,
				$funcName = "funcName1",
				$errMsg = "errMsg1",
				$fileName = __FILE__,
				$line = __LINE__,
				);
		};
		ok(!$@);
		is(Cv->getErrStatus(), $status, "errStatus");
		is($err1->[0], $status);
		is($err1->[1], $funcName);
		is($err1->[2], $errMsg);
		is($err1->[3], $fileName);
		is($err1->[4], $line);
		is($err1->[5], $data);
		is($prevError, \&myerror);
		is($prevData, "mydata");
	}
	
	if (3) {
		Cv->setErrMode(2);
		is(Cv->getErrMode(), 2, "errMode2");
		my ($status, $funcName, $errMsg, $fileName, $line, $data);
		my $err2;
		my $prevError = Cv->redirectError(
			sub {
				$err2 = \@_;
				# print STDERR "myerror1:\n", D(@_);
			},
			$data = "mydata2",
			my $prevData,
			);
		eval {
			Cv->error(
				$status = -3,
				$funcName = "funcName2",
				$errMsg = "errMsg2",
				$fileName = __FILE__,
				$line = __LINE__,
				);
		};
		ok(!$@);				# XXXXX
		is(Cv->getErrStatus(), $status, "errStatus");
		is($err2, undef);
	}

	if (4) {
		Cv->setErrMode(0);
		Cv->redirectError(sub {});
		$line = __LINE__ + 1;
		eval { Cv::cvCreateImage([-1, -1], 8, 3); };
		err_is("OpenCV Error: Unknown error code -25 (Bad input roi) in cvInitImageHeader");
	}
}
