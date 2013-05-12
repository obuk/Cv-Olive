# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

our %build_reqs = (
	'perl-ExtUtils-ParseXS'   => '2.220',
	'perl-ExtUtils-PkgConfig' => '1.120',
);

our %PREREQ_PM = (
	'ExtUtils::ParseXS'   => $build_reqs{'perl-ExtUtils-ParseXS'},
	'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
	'Test::Number::Delta' => '1.030',
	'Test::Exception'     => '0.310',
);

if ($^O eq 'cygwin') {
	$PREREQ_PM{'ExtUtils::MM_Cygwin'} =
		$build_reqs{'perl-ExtUtils-MM_Cygwin'} = '6.620';
}

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
