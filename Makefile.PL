# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker 6.31;

use lib qw(./lib);
use Cv::Config;
my $cf = new Cv::Config;

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


# make lib/Cv/Constant.pm
{
	use version;
	my $dst = "lib/Cv/Constant.pm";
	my $tmp = "a.pm";
	unless (&dumpconst('-v', '-o', $tmp, @{$cf->{include}}) == 0) {
		my $fallback = 'fallback/Constant.pm';
		my $ver = $cf->_version;
		my @ver = sort { $b <=> $a } grep { ref $_ && $_ <= $ver } map {
			/-([\d\.]+)$/ && version->parse($1) } glob("$fallback-*");
		die "$0: can't make $dst\n" unless @ver;
		&cp("$fallback-$ver[0]", $tmp);
	}
	if (!-f $dst || &cmp('-s', $tmp, $dst) != 0) {
		&mv($dst, "$dst.bak") if -f $dst;
		&cp($tmp, $dst);
	}
	&rm('-f', $tmp);
}


my $PREREQ_PM = {
	ExtUtils::ParseXS => 2.22,
	Getopt::Long => 2.38,
};

if ($^O eq 'cygwin') {
	$PREREQ_PM = {
		%$PREREQ_PM,
		ExtUtils::MM_Cygwin => 6.62,
	};
}

my @dir = qw(Test);
push(@dir, qw(Qt)) if $cf->hasqt;

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
	dynamic_lib => $cf->dynamic_lib,
	DIR => [ @dir ],
	LICENSE => 'perl',
	clean => {
		FILES => [
			@perl_h_patched, 'lib/Cv/Constant.pm*', 'a.pm', '*.tmp',
			't/ref-*.pm', 'camera.xml', 'contours.xml', 'sample.avi',
			'_Inline', 'cover_db', '.lib',
			] },
	);

sub MY::test_via_harness {
    my($self, $perl, $tests) = @_;
    return qq{\t$perl "-MExtUtils::Command::MM" }.
           qq{"-e" "test_harness(\$(TEST_VERBOSE), '\$(INST_LIB)', '\$(INST_ARCHLIB)', '.lib/lib', '.lib/arch')" $tests\n};
}

sub MY::postamble {
	"
ref:
	./tools/ref2pl-all.pl |sh -x

const:
	./tools/dumpconst-all.pl |sh -x

cover:
	cover -delete
	-HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
	find cover_db -type d |xargs chmod +rx

Cv.xs:	Cv.inc

";
}

sub AUTOLOAD {
	our $AUTOLOAD;
	(my $program = $AUTOLOAD) =~ s/.*:://;
	my @program = grep { -x $_ } (
		"./tools/$program.pl",
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
