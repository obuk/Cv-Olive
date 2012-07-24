#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;

use File::Basename;
use Data::Dumper;
use lib qw(blib/lib blib/arch);
use Cv;

our %cv;
our %file;

sub loadref {
	my ($a, $b, $c) = CV_VERSION();
	my $refpm;
	while ($c >= 0) {
		my $pm = dirname($0) . "/../t/ref-$a.$b.$c.pm";
		$refpm ||= $pm;
		return $pm if eval { require $pm };
		if (--$c < 0) {
			last unless --$b >= 0;
			$c = 9;
		}
	}
	undef;
}

&loadref;

our %TBD;
$TBD{$_} = 1 for keys %cv;

sub d {
	my $name = shift;
	my $ref = eval "\\%$name";
	for (keys %$ref) {
		d($name . $_) if /^\w+::$/;
		my $p = $ref->{$_};
		next unless my $code = eval "${p}{CODE}";
		if (/^cv[A-Zm]/) {
			# print "$_\n";
			delete $TBD{$_};
		} else {
			delete $TBD{"cv$_"};
		}
	}
}

&d(q(Cv::));

my $wiki = 0;

if ($wiki) {
	print (
		"{| border=1 cellpadding=5 cellspacing=0 width=90% align=center\n",
		"! module || grep ocv::cfunction *.rst\n",
		"! defined/total\n",
		"! width=50% | note\n",
		);
}
my $sum_defined;
my $sum_total;
foreach my $file (sort keys %file) {
	my $funcs = $file{$file};
	# print Data::Dumper->Dump([$funcs], [qw($funcs)]);

	my @ok = ();
	my @tbd = ();
	for (keys %$funcs) {
		if ($TBD{$_}) {
			push(@tbd, $_);
		} else {
			push(@ok, $_);
		}
	}

	my $defined = scalar @ok;
	my $total = scalar @ok + scalar @tbd;

	my $percent = sprintf("%5.1f%%", $defined / $total * 100);
	if ($wiki) {
		print (
			"|- valign=top\n",
			"| $file\n",
			"| align=right | <span style=\"white-space: nowrap;\">$defined/$total ($percent)</span>\n",
			"| ", @tbd? 'tbd: <toggledisplay> ' . join(', ', @tbd) . ' </toggledisplay>' : '', "\n",
			);
	} else {
		my $tbd = scalar @tbd;
		my $msg = $tbd? " + ($tbd)" : "";
		print (
			"=item $file: $defined$msg\n\n",
			join(', ', map { substr($_, 2) } sort(@ok)), "\n\n",
			);
		print (
			"(TBD) ", join(', ', map { substr($_, 2) } sort(@tbd)), "\n\n",
			) if @tbd;
	}
	$sum_defined += $defined;
	$sum_total += $total;
}

if ($wiki) {
	my $percent = sprintf("%5.1f%%", $sum_defined / $sum_total * 100);
	print (
		"|- valign=top\n",
		"| colspan=2 |\n",
		"| align=right | <span style=\"white-space: nowrap;\">$sum_defined/$sum_total ($percent)</span>\n",
		"|\n",
		"|}\n",
		);
} else {
	my $percent = sprintf("%5.1f%%", $sum_defined / $sum_total * 100);
	print "=item coverage: $sum_defined/$sum_total ($percent)\n\n";
}

