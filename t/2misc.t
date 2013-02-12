# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 42;
use File::Basename;
use lib dirname($0);
use MY;
BEGIN { use_ok('Cv', -more) }
use POSIX;

sub cbrt {
    my ($x) = @_; my $sign = 1;
    ($x, $sign) = (-$x, -1) if $x < 0;
    $sign * $x ** (1/3);
}

for my $x (-1.5, -1, -0.5, 0, 0.5, 1, 1.5) {
    my $prec = 7;
    my $a = sprintf("%.${prec}g", cvCbrt($x));
    my $b = sprintf("%.${prec}g", cbrt($x));
    is($a, $b, "cvCbrt($x)");
}

for my $x (-1.5, -1, -0.5, 0, 0.5, 1, 1.5) {
    my $prec = 7;
    my $a = sprintf("%.${prec}g", cvSqrt($x));
    my $b = $x >= 0? sprintf("%.${prec}g", sqrt($x)) : 'nan';
    is($a, $b, "cvSqrt($x)");
}

for my $x (-1, -0.5, 0, 0.5, 1) {
    my $y = POSIX::floor($x) + 0;
    is(cvFloor($x), $y, "cvFloor($x)");
}

for my $x (-1, -0.5, 0, 0.5, 1) {
    my $y = POSIX::ceil($x) + 0;
    is(cvCeil($x), $y, "cvCeil($x)");
}

for (1 .. 10) {
    my ($y, $x) = (rand(), rand());
    my $a = cvFastArctan($y, $x);
    redo unless my $b = 180 / CV_PI * atan2($y, $x);
    $b = $a if (abs($a / $b) - 1) <= 0.1; # ignoring error < 10%
    is($a, $b, "cvFastArctan($y, $x)");
}

sub round {
    my ($x) = (@_);
    ($x >= 0)? POSIX::floor($x + 0.5) : POSIX::ceil($x - 0.5);
}

for my $x (-1.4, -1, -0.6, 0, 0.6, 1, 1.4) {
    is(cvRound($x), round($x), "round($x)");
}
