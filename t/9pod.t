# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::Pod 1.00;
# eval "use Test::Pod 1.00";
# plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
my @poddirs = qw(lib lib/Cv);
all_pod_files_ok(all_pod_files(@poddirs));
