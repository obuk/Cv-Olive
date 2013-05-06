# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

our %PREREQ_PM = (
	'ExtUtils::ParseXS' => 2.22,
	'ExtUtils::PkgConfig' => 1.12,
	'Test::Number::Delta' => 1.03,
	'Test::Exception' => 0.31,
	$^O eq 'cygwin' ? ('ExtUtils::MM_Cygwin' => 6.62) : (),
);

unless (eval join('; ', (map "use $_ $PREREQ_PM{'$_'}", keys %PREREQ_PM), 1)) {
    warn "$@\n";
    WriteMakefile(
        PREREQ_FATAL => 1,
        PREREQ_PM => \%PREREQ_PM,
		);
    exit 1; # not reached
}

use lib qw(../lib);
use Cv::Config;

my $cf = new Cv::Config;

WriteMakefile(
	NAME => 'Cv::Histogram',
	VERSION_FROM => 'lib/Cv/Histogram.pm',
	ABSTRACT_FROM => 'lib/Cv/Histogram.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	PREREQ_PM => \%PREREQ_PM,
	%Cv::Config::MM,
	INC => '-I. -I..',
	XSOPT => '-C++ -hiertype',
);
