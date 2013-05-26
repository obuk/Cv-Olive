# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

our %CONFIGURE_REQUIRES = (
	'ExtUtils::ParseXS'   => '2.220',
	'ExtUtils::PkgConfig' => '1.120',
	$^O eq 'cygwin' ? ('ExtUtils::MM_Cygwin' => '6.620') : (),
);

our %TEST_REQUIRES = (
	'Test::Number::Delta' => '1.030',
	'Test::Exception'     => '0.310',
	);

our %PREREQ_PM = ( %CONFIGURE_REQUIRES );

use lib qw(../lib);
use Cv::Config;

my $cf = new Cv::Config;
my $name = 'BGCodeBookModel';

WriteMakefile(
	NAME => "Cv::$name",
	VERSION_FROM => "lib/Cv/$name.pm",
	ABSTRACT_FROM => "lib/Cv/$name.pm",
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	CONFIGURE_REQUIRES => \%CONFIGURE_REQUIRES,
	TEST_REQUIRES => \%TEST_REQUIRES,
	PREREQ_PM => \%PREREQ_PM,
	%Cv::Config::MM,
	INC => '-I. -I..',
	XSOPT => '-C++ -hiertype',
);
