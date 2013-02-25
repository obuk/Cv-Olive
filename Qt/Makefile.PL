# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(../lib);
use Cv::Config;
my $cf = new Cv::Config;

my $PREREQ_PM = {
	ExtUtils::ParseXS => 2.22,
};

if ($^O eq 'cygwin') {
	$PREREQ_PM = {
		%$PREREQ_PM,
		ExtUtils::MM_Cygwin => 6.62,
		Test::Number::Delta => 1.03,
		Test::Exception => 0.31,
	};
}

WriteMakefile(
	NAME => 'Cv::Qt',
	VERSION_FROM => 'lib/Cv/Qt.pm',
	PREREQ_PM => $PREREQ_PM,
	ABSTRACT_FROM => 'lib/Cv/Qt.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	INC => '-I. -I..',
	LIBS => $cf->libs,
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,
);

sub MY::test_via_harness {
    my($self, $perl, $tests) = @_;
    return qq{\t$perl "-MExtUtils::Command::MM" }.
           qq{"-e" "test_harness(\$(TEST_VERBOSE), '\$(INST_LIB)', '\$(INST_ARCHLIB)', '../.lib/lib', '../.lib/arch')" $tests\n};
}
