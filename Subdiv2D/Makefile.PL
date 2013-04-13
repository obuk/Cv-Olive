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
	exit 0;
}

my $cf = new Cv::Config;

WriteMakefile(
	NAME => 'Cv::Subdiv2D',
	VERSION_FROM => 'lib/Cv/Subdiv2D.pm',
	ABSTRACT_FROM => 'lib/Cv/Subdiv2D.pm',
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	PREREQ_PM => {
		ExtUtils::ParseXS => 2.22,
		ExtUtils::PkgConfig => 1.12,
		Test::Number::Delta => 1.03,
		Test::Exception => 0.31,
		$^O eq 'cygwin' ? (ExtUtils::MM_Cygwin => 6.62) : (),
	},
	%Cv::Config::MM,
	INC => '-I. -I..',
	XSOPT => '-C++ -hiertype',
);
