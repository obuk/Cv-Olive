#!/usr/bin/env perl

use strict;
use warnings;
use lib qw(blib/lib blib/arch);
use Cv;
use YAML::Any qw(Dump);
use Perl6::Say;

my %x = Cv->GetBuildInformation;
say Dump(\%x);
