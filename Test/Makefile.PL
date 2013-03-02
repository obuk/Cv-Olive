# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(../lib);
eval "use Cv::Config";
if ($@) {
	warn "=" x 60, "\n";
	warn "See README to install this module\n";
	warn "=" x 60, "\n";
	exit 1;
}

my $cf = new Cv::Config;

my %PREREQ_PM = (
	PREREQ_PM => {
		ExtUtils::ParseXS => 2.22,
		ExtUtils::PkgConfig => 1.14,
		Test::Number::Delta => 1.03,
		Test::Exception => 0.31,
		$^O eq 'cygwin' ? (ExtUtils::MM_Cygwin => 6.62) : (),
	},
);

WriteMakefile(
	NAME => 'Cv::Test',
	VERSION_FROM => 'lib/Cv/Test.pm',
	ABSTRACT_FROM => 'lib/Cv/Test.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	%PREREQ_PM,
	%Cv::Config::MM,
	INC => '-I. -I..',
	XSOPT => '-C++ -hiertype',

	INST_ARCHLIB => '../.lib/arch',
	INST_SCRIPT => '../.lib/script',
	INST_BIN => '../.lib/bin',
	INST_LIB => '../.lib/lib',
	INST_MAN1DIR => '../.lib/man1',
	INST_MAN3DIR => '../.lib/man3',
);

sub MY::postamble {
	"
Test.xs:	../lib/Cv/Cv.inc

";
}
