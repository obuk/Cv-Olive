# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(../lib);
use Cv::Config;
my $cf = new Cv::Config;

WriteMakefile(
	NAME => 'Cv::Typemap',
	VERSION_FROM => 'lib/Cv/Typemap.pm',
	PREREQ_PM => {},
	ABSTRACT_FROM => 'lib/Cv/Typemap.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	INC => '-I. -I..',
	LIBS => $cf->libs,
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,
);
