# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 26;

BEGIN {
	use_ok('Cv');
}

use Data::Dumper;

sub D (\@) {
	Data::Dumper->Dump(
		[@{$_[0]}],
		[map { "\$_[$_]" } 0 .. $#{$_[0]}]
		);
}

SKIP: {
	skip("need v2.0.0+", 25) unless cvVersion() >= 2.000000;
	Cv->setErrMode(1);
	my $can_hook = Cv->getErrMode() == 1;
	$can_hook = 0 if $^O eq 'cygwin';
	Cv->setErrMode(0);
	skip("can't hook cv:error", 25) unless $can_hook;

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
		ok(!$@);
		is(Cv->getErrStatus(), $status, "errStatus");
		is($err2, undef);
	}
	
	if (4) {
		Cv->setErrMode(0);
		Cv->redirectError(\&myerror);
		my $img = eval { Cv->createImage([-1, -1], 8, 3); };
		ok($@);
	}
}
