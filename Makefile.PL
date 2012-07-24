# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(./lib);
use Cv::Config;
my $cf = new Cv::Config;
my %with = ( QT => 0 );

my @perl_h = qw(perl.h sv.h pp.h);
my @perl_h_patched = ();

{
	use Config;
	my $CORE = join('/', $Config{archlib}, 'CORE');
	foreach my $h (@perl_h) {
		if (open(PHI, "<$CORE/$h")) {
			my $patched = "lib/Cv/$h";
			open(PHO, ">$patched");
			while (<PHI>) {
				s/\bstruct\s+cv\b/struct STRUCT_CV/g;
				s/\bNORMAL\b/Perl_NORMAL/g;
				print PHO;
			}
			close PHO;
			close PHI;
			push(@perl_h_patched, $patched);
		}
	}
}

sub decr (\@) {
	my $v = shift;
	if (--$v->[2] < 0) {
		$v->[2] = 99;
		if (--$v->[1] < 0) {
			$v->[1] = 99;
			--$v->[0];
		}
	}
}

if (&dumpconst(qw(-v -o a.pm), @{$cf->{include}}) == 0) {
	if (!-f "lib/Cv/Constant.pm" || &cmp(qw(-s a.pm lib/Cv/Constant.pm)) != 0) {
		&mv(qw(lib/Cv/Constant.pm lib/Cv/Constant.pm.bak));
		&mv(qw(a.pm lib/Cv/Constant.pm));
	}
} else {
	my @v = map { $_ + 0 } ($cf->version =~ /(\d+)\.(\d{3})(\d{3})/);
	for (; $v[0] >= 0; decr(@v)) {
		if (-f (my $f = "./fallback/Constant.pm-".join('.', @v))) {
			&cp($f, qw(lib/Cv/Constant.pm));
			last;
		}
	}
	die "$0: can't make lib/Cv/Constant.pm\n" unless $v[0] >= 0;
}

&rm(qw(-f a.pm));

my $PREREQ_PM = {
	Data::Dumper => 0,
	Scalar::Util => 0,
	File::Basename => 0,
	List::Util => 0,
	Time::HiRes => 0,
	ExtUtils::ParseXS => 2.22,
	Cwd => 0,
};

if ($^O eq 'cygwin') {
	$PREREQ_PM = {
		%$PREREQ_PM,
		ExtUtils::MM_Cygwin => 6.62,
	};
}

WriteMakefile(
	NAME => 'Cv',
	VERSION_FROM => "lib/Cv.pm", # finds $VERSION
	PREREQ_PM => $PREREQ_PM,
	ABSTRACT_FROM => "lib/Cv.pm",
	AUTHOR => 'MASUDA Yuta <yuta.cpan@gmail.com>',
	LIBS => $cf->libs,
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,
	DEFINE => join(' ', map { "-DWITH_$_=$with{$_}" } keys %with),
	MYEXTLIB => 'xlib/libxs$(LIB_EXT)',
	dynamic_lib => $cf->dynamic_lib,
	INC => "-I. -I..",
	DIR => [ qw(xlib) ],
	clean => {
		FILES => [
			'_Inline', 'cover_db',
			'camera.xml', 'contours.xml', 'sample.avi', '*.tmp',
			'auto', @perl_h_patched,
			'lib/Cv/Constant.pm',
			] },
	);

sub MY::postamble {
	"
Cv.xs:	lib/Cv/typemap.h

ref:
	./support/ref2pl-all.pl |sh -x

const:
	./support/dumpconst-all.pl |sh -x

cover:
	cover -delete
	-HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
	find cover_db -type d |xargs chmod +rx

\$(MYEXTLIB):
	cd xlib && \$(MAKE) \$(PASSTHRU)

";
}

sub AUTOLOAD {
	our $AUTOLOAD;
	(my $program = $AUTOLOAD) =~ s/.*:://;
	my @program = grep { -x $_ } (
		"./support/$program.pl",
		"/usr/local/bin/$program",
		"/usr/bin/$program",
		"/bin/$program",
	);
	if (@program) {
		print STDERR join(' ', $program[0], @_), "\n";
		return system($program[0], @_);
	}
	die "$0: ?$program\n";
}
