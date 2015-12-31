# -*- mode: perl -*-

my $prereq_pm = sub {
    requires 'B::Deparse' => 0;
    requires 'Cwd' => '3.60';
    requires 'Devel::CheckLib' => '1.05';
    requires 'Data::Structure::Util' => '0.16';
    requires 'ExtUtils::MakeMaker' => '7.10';
    requires 'ExtUtils::ParseXS' => '3.30';
    requires 'File::Basename' => 0;
    requires 'File::Spec::Functions' => '3.60';
    requires 'File::Temp' => '0.2304';
    requires 'Getopt::Long' => '2.48';
    requires 'Scalar::Util' => '1.42';
    requires 'version' => '0.9912';
    if ($^O eq 'cygwin') {
        requires 'ExtUtils::MM_Cygwin' => '6.620';
    }
};

on 'configure' => $prereq_pm;
on 'build' => $prereq_pm;

on 'test' => sub {
    requires 'List::Util' => '1.42';
    requires 'POSIX' => 0;
    requires 'Test::Exception' => '0.43';
    requires 'Test::More' => '1.001014';
    requires 'Test::Number::Delta' => '1.06';
    requires 'Time::HiRes' => '1.9728';
};
