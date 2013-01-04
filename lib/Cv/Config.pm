# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Config;

use 5.008008;
use strict;
use warnings;
use Carp;
use Cwd qw(abs_path);
use File::Basename;
use version;
BEGIN { eval "use Cv::Constant" };

our $VERSION = '0.22';

our %opencv;
our %C;
our $cf;
our $verbose = 0;

sub new {
	$cf ||= bless {};
	$cf;
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
		$self->{LIBS} = [ $opencv{libs} ];
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
		my @inc = ("-I$cvdir"); my %inced = ();
		my $ccflags = $opencv{cflags};
		my @ccflags = ();
		$ccflags =~ s/(^\s+|\s+$)//g;
		foreach (split(/\s+/, $ccflags)) {
			if (/^-I/) {
				s/(-I[\w\/]*)\/opencv/$1/;
				next if $inced{$_};
				$inced{$_} = 1;
				push(@inc, $_);
			} else {
				push(@ccflags, $_);
			}
		}
		$self->{include} = [map { substr($_, 2) } keys %inced];
		$self->{CCFLAGS} = join(' ', @inc, @ccflags);
	}
	$self->{CCFLAGS};
}


sub _version {
	my $self = shift;
	unless (defined $self->{version}) {
		return $self->{version} = Cv::cvVersion()
			if Cv->can('cvVersion');
		my $c = "/tmp/version$$.c";
		warn "Compiling $c to get Cv version.\n" if $verbose;
		my $CC = $self->cc;
		my $CCFLAGS = $self->ccflags;
		my $LIBS = join(' ', @{$self->libs});
		if (my $dynamic_lib = $self->dynamic_lib) {
			if ($dynamic_lib->{OTHERLDFLAGS}) {
				$LIBS .= " " . $dynamic_lib->{OTHERLDFLAGS};
			}
		}
		if (open C, ">$c") {
			print C <<"----";
#include <stdio.h>
#include <opencv/cv.h>
main()
{
	printf("%d.%d.%d\\n",
		   CV_MAJOR_VERSION, CV_MINOR_VERSION, CV_SUBMINOR_VERSION);
	exit(0);
}
----
	;
			close C;
			warn "$CC $CCFLAGS -o a.exe $c $LIBS\n" if $verbose;
			chop(my $v = `$CC $CCFLAGS -o a.exe $c $LIBS && ./a.exe`);
			unless ($? == 0) {
				unlink($c);
				die "$0: can't compile $c to get Cv version.\n",
				"$0: your system has installed opencv?\n";
			}
			unlink($c, 'a.exe');
			$self->{version} = version->parse($v);
		} else {
			die "$0: can't open $c.\n";
		}
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


sub c {
	my $self = shift;
	my %c = (
		CC       => $self->cc,
		LD       => $self->cc,
		CCFLAGS  => $self->ccflags,
		LIBS     => $self->libs,
		# MYEXTLIB => $self->myextlib,
		TYPEMAPS => $self->typemaps,
		AUTO_INCLUDE => join("\n", (
								 '#undef do_open',
								 '#undef do_close',
							 )),
		);
	# print STDERR "\$C{$_} = $C{$_}\n" for keys %c;
	%c;
}


BEGIN {
	foreach my $key (qw(cflags libs)) {
		eval {
			no warnings;
			chop(my $value = `pkg-config opencv --$key`);
			$opencv{$key} = $value;
		};
		if ($?) {
			warn "=" x 60, "\n";
			warn "See README to install this module\n";
			warn "=" x 60, "\n";
			exit 1;
		}
	}
	$cf = &new;
	%C = $cf->c;
}

1;
