# -*- mode: perl -*-

requires 'ExtUtils::MakeMaker' => '7.1';
requires 'File::Spec::Functions' => '3.48_01';
requires 'File::Temp' => '0.2304';
requires 'ExtUtils::ParseXS' => '2.190';
requires 'version' => '0.770';

test_requires 'Test::More' => '1.001014';
test_requires 'Test::Number::Delta' => '1.030';
test_requires 'Test::Exception' => '0.310';

if ($^O eq 'cygwin') {
	requires 'ExtUtils::MM_Cygwin' => '6.620';
}
