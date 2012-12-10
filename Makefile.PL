# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

use lib qw(./lib);
use Cv::Config;
my $cf = new Cv::Config;
my %with = ( QT => 0, T => 0 );

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


# make lib/Cv/Constant.pm
{
	my $dst = "lib/Cv/Constant.pm";
	my $tmp = "a.pm";
	unless (&dumpconst('-v', '-o', $tmp, @{$cf->{include}}) == 0) {
		my @v = map { $_ + 0 } ($cf->version =~ /(\d+)\.(\d{3})(\d{3})/);
		for (; $v[0] >= 0; decr(@v)) {
			if (-f (my $f = "./fallback/Constant.pm-".join('.', @v))) {
				$tmp = $f;
				last;
			}
		}
		die "$0: can't make $dst\n" unless $v[0] >= 0;
	}
	if (!-f $dst || &cmp('-s', $tmp, $dst) != 0) {
		&mv($dst, "$dst.bak") if -f $dst;
		&cp($tmp, $dst);
	}
	&rm('-f', $tmp);
}


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
	dynamic_lib => $cf->dynamic_lib,
	INC => "-I. -I..",
	DIR => [
		qw(Highgui),
	],
	clean => {
		FILES => [
			'_Inline', 'cover_db',
			'camera.xml', 'contours.xml', 'sample.avi', '*.tmp',
			'auto', @perl_h_patched,
			't/ref-*.pm',
			'lib/Cv/Constant.pm',
			] },
	);

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
