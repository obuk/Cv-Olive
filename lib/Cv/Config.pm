# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Config;

use 5.008008;
use strict;
use warnings;
use Carp;
use Cwd qw(abs_path);
BEGIN { eval "use Cv::Constant" };

our $VERSION = '0.14';

our %opencv;
our %C;
our $cf;

sub new {
	$cf ||= bless {};
	$cf;
}

sub cvdir {
	my $self = shift;
	unless (defined $self->{cvdir}) {
		my @mypath = split(/\/+/, $INC{'Cv/Config.pm'});
		my $cvdir = join('/', @mypath[0..$#mypath-1]);
		$self->{cvdir} = abs_path($cvdir);
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


sub version {
	my $self = shift;
	return Cv::cvVersion() if Cv->can('cvVersion');
	&Cv::Constant::CV_MAJOR_VERSION +
		&Cv::Constant::CV_MINOR_VERSION * 1e-3 +
		&Cv::Constant::CV_SUBMINOR_VERSION * 1e-6;
}


=xxx

sub myextlib {
	my $self = shift;
	unless (defined $self->{MYEXTLIB}) {
		my $extlib;
		foreach (@INC) {
			my $ext = $^O eq 'cygwin' ? ".dll" : ".so";
			my $so = "$_/auto/Cv/Cv$ext";
			if (-x $so) {
				$extlib = abs_path($so);
				last;
			}
		}
		$self->{MYEXTLIB} = $extlib;
	}
	$self->{MYEXTLIB};
}

=cut


sub c {
	my $self = shift;
	my %C = (
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
	# print STDERR "\$C{$_} = $C{$_}\n" for keys %C;
	%C;
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
