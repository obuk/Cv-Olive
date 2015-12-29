# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Config;

use 5.008008;
use strict;
use warnings;
use Carp;
use Cwd qw(abs_path);
use File::Basename;
# use ExtUtils::PkgConfig;
use version;

our $VERSION = '0.30';

our %opencv;
our %MM;
our %C;

our $verbose = 0;

sub new {
	bless {};
}

sub cvdir {
	my $self = shift;
	unless (defined $self->{cvdir}) {
		(my $me = __PACKAGE__ . '.pm') =~ s|::|/|g;
		$self->{cvdir} = abs_path(dirname($INC{$me}));
	}
	$self->{cvdir};
}


sub typemaps {
	my $self = shift;
	my $cvdir = $self->cvdir;
	unless (defined $self->{TYPEMAPS}) {
		$self->{TYPEMAPS} = [ "$cvdir/typemap" ];
	}
	$self->{TYPEMAPS};
}


sub cc {
	my $self = shift;
	unless (defined $self->{CC}) {
		$self->{CC} = $ENV{CXX} || $ENV{CC} || 'c++';
	}
	$self->{CC};
}


sub libs {
	my $self = shift;
	unless (defined $self->{LIBS}) {
		my @libs = split(/\s+/, $opencv{libs});
		if ($libs[0] =~ m{(/.*)/libopencv}) {
			my $dir = $1;
			s{$dir/lib}{-l} for @libs;
			unshift(@libs, "-L$dir");
		}
		s{(-\d+\.\d+)?(\.(so|dll))?$}{} for @libs;
		$self->{LIBS} = [ join(' ', @libs) ];
	}
	$self->{LIBS};
}


sub dynamic_lib {
	my $self = shift;
	my $cc = $self->cc;
	unless (defined $self->{dynamic_lib}) {
		if (open(CC, "$cc -v 2>&1 |")) {
			my %cf;
			while (<CC>) {
				if (/^Configured with:\s*/) {
					while (/(-[-\w]+)=('[^']*'|[^\s]*)/g) {
						$cf{$1} = $2;
					}
				}
			}
			$self->{dynamic_lib} = { };
			if (my $rpath = $cf{'--libdir'} || $cf{'--libexecdir'}) {
				$self->{dynamic_lib}{OTHERLDFLAGS} = "-Wl,-rpath=$rpath",
			}
			close CC;
		}
	}
	$self->{dynamic_lib};
}


sub ccflags {
	my $self = shift;
	my $cvdir = $self->cvdir;
	unless (defined $self->{CCFLAGS}) {
		my @inc = ("-I$cvdir"); my %seen = ();
		my @ccflags = ();
		foreach (split(/\s+/, $opencv{cflags})) {
			if (/^-I/) {
				s/(-I.*)\bopencv/$1/;
				next if $seen{$_}++;
				push(@inc, $_);
			} else {
				push(@ccflags, $_);
			}
		}
		$self->{CCFLAGS} = join(' ', @inc, @ccflags);
	}
	$self->{CCFLAGS};
}


sub hasqt {
	my $self = shift;
	unless (defined $self->{hasqt}) {
		$self->{hasqt} = do {
			$self->run_c(<<END, 'to check you have qt');
#include <stdio.h>
#include <opencv/cv.h>
#include <opencv/highgui.h>
int main()
{
  CvFont font = cvFontQt("Times");
  exit(0);
}
END
			$? == 0;
		};
	}
	$self->{hasqt};
}

sub hasnonfree {
	my $self = shift;
	unless (defined $self->{hasnonfree}) {
		$self->{hasnonfree} = do {
			my $output = $self->run_c(<<END);
#include <stdio.h>
#include <opencv/cv.h>
#include <opencv2/opencv_modules.hpp>
int main()
{
#ifdef HAVE_OPENCV_NONFREE
  printf("yes\\n");
  exit(0);
#else
  exit(1);
#endif
}
END
			$? == 0 && $output;
		};
	}
	$self->{hasnonfree};
}


use File::Slurp qw/ write_file /;
use File::Spec::Functions qw/ catdir /;
use File::Temp qw/ tempdir /;
use Parse::CommandLine;

sub run_c {
	my $self = shift;
	my $option = { src => '.c++', out => '.out' };
	if (ref $_[0]) {
		my $x = shift;
		$option->{$_} = $x->{$_} for keys %$x;
	}
	my $code = shift;
	my $hint = shift || '';
	my $child_error = 0;
	my $output;
	{
		local $?;
		my $tempdir = tempdir(CLEANUP => 1);
		my $src = catdir $tempdir, join('', 'cv', $$, $option->{src});
		my $out = catdir $tempdir, join('', 'a', $option->{out});
		warn join(' ', "Compiling $src", $hint), "\n" if $verbose;
		write_file($src, $code) or croak "$0: can't write $src.\n";
		my @compile = (
			$self->cc, $src, '-o', $out,
			map { parse_command_line($_) } $opencv{cflags}, $opencv{libs},
		);
		warn "@compile\n" if $verbose;
		system @compile;
		$output = `$out` if ($child_error = $?) == 0;
	}
	$? = $child_error;
	$output;
}


sub _version {
	my $self = shift;
	unless (defined $self->{version}) {
		$self->{version} = version->parse($opencv{modversion});
	}
	$self->{version};
}


sub version {
	my $self = shift;
	if ($self->_version->normal =~ /v?(\d+)\.(\d+)\.(\d+)/) {
		return sprintf("%d.%03d%03d", $1, $2, $3);
	}
	undef;
}


BEGIN {
	# %opencv = ExtUtils::PkgConfig->find('opencv');
	foreach my $key (qw(cflags libs modversion)) {
		no warnings 'uninitialized';
		chop(my $value = `pkg-config opencv --$key`) or die $!;
		$opencv{$key} = $value;
	}
 
	my $cf = __PACKAGE__->new;

	# ExtUtils::MakeMaker
	%MM = (
		CC       => $cf->cc,
		LD       => $cf->cc,
		CCFLAGS  => $cf->ccflags,
		LIBS     => $cf->libs,
		# MYEXTLIB => $cf->myextlib,
		TYPEMAPS => $cf->typemaps,
		);

	# Inline::C
	%C = (
		%MM,
		AUTO_INCLUDE => join("\n", (
								 '#define __Inline_C',
								 '#include "Cv.inc"',
								 '',
							 )),
		);
}

1;
