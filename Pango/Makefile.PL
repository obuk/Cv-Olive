# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;
use ExtUtils::PkgConfig;

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
		ExtUtils::PkgConfig => 1.12,
		Pango => 1.223,
	},
);

WriteMakefile(
	NAME => 'Cv::Pango',
	VERSION_FROM => 'lib/Cv/Pango.pm',
	ABSTRACT_FROM => 'lib/Cv/Pango.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	%PREREQ_PM,
	%Cv::Config::MM,
	INC => '-I. -I..',
	XSOPT => '-C++ -hiertype',
);

sub MY::test_via_harness {
    my($self, $perl, $tests) = @_;
    return qq{\t$perl "-MExtUtils::Command::MM" }.
           qq{"-e" "test_harness(\$(TEST_VERBOSE), '\$(INST_LIB)', '\$(INST_ARCHLIB)', '../.lib/lib', '../.lib/arch')" $tests\n};
}
