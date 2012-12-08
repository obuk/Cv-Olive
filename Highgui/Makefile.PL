# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(../lib);
use Cv::Config;
my $cf = new Cv::Config;

WriteMakefile(
    NAME => 'Cv::Highgui',
    VERSION_FROM => 'lib/Cv/Highgui.pm',
    PREREQ_PM => {},
    ABSTRACT_FROM => 'lib/Cv/Highgui.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
    DEFINE => '',
    INC => '-I.',
	LIBS => $cf->libs,
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,
);
