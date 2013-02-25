# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(../lib);
use Cv::Config;
my $cf = new Cv::Config;

WriteMakefile(
	NAME => 'Cv::Test',
	VERSION_FROM => 'lib/Cv/Test.pm',
	PREREQ_PM => {},
	ABSTRACT_FROM => 'lib/Cv/Test.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	INC => '-I. -I..',
	LIBS => $cf->libs,
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,

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
