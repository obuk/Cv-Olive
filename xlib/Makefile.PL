# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
use ExtUtils::MakeMaker;

use lib "../lib";
use Cv::Config;

my $cf = new Cv::Config;

WriteMakefile(
    NAME   => 'libxs',
    SKIP   => [qw(all static static_lib dynamic dynamic_lib)],
    clean  => {'FILES' => 'libxs$(LIB_EXT)'},
    CC => $cf->cc,
    LD => $cf->cc,
	CCFLAGS => $cf->ccflags,
    XSOPT => '-C++ -hiertype',
    INC => '-I. -I.. -I../.. -I../lib/Cv',
);

sub MY::top_targets {
	'
all :: static
pure_all :: static
static :: libxs$(LIB_EXT)
libxs$(LIB_EXT): $(O_FILES)
	$(AR) cr libxs$(LIB_EXT) $(O_FILES)
	$(RANLIB) libxs$(LIB_EXT)

$(O_FILES):	xs.h ../lib/Cv/typemap.h

';
}
