# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::Pod 1.00;
my @poddirs = qw(blib);
all_pod_files_ok(all_pod_files(@poddirs));
