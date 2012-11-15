# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
# use Test::More qw(no_plan);
use Test::More tests => 127;

BEGIN {
	use_ok('Cv');
}

sub equal($$) {
	my ($a, $b) = splice(@_, 0, 2);
	return undef unless ref $a eq 'ARRAY';
	return undef unless ref $b eq 'ARRAY';
	return undef unless @$a == @$b;
	foreach my $i (0 .. $#{$a}) {
		return undef unless $a->[$i] == $b->[$i];
	}
	return 1;
}

if (1) {
	my $stor = Cv::MemStorage->new(8192);
	ok($stor->isa('Cv::MemStorage'));

	my $seq = Cv::Seq::Point->new(CV_32SC2, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	# my $type_name = Cv::cvTypeOf($seq)->type_name;
	# print STDERR $type_name, "\n";
	# is($typename, "opencv-sequence-tree");

	my @pts = (map { [ $_ * 10 + 1, $_ * 10 + 2 ] } 0 .. 9);
	$seq->Push(@pts);
	ok(equal($seq->GetSeqElem($_), $pts[$_])) for 0 .. $#pts;

	$seq->SeqInvert;
	@pts = reverse(@pts);
	ok(equal($seq->GetSeqElem($_), $pts[$_])) for 0 .. $#pts;

	$seq->Reverse;
	@pts = reverse(@pts);
	ok(equal($seq->GetSeqElem($_), $pts[$_])) for 0 .. $#pts;
}

if (2) {
	my $stor = Cv::MemStorage->new(8192);
	ok($stor->isa('Cv::MemStorage'));

	my $seq = Cv::Seq::Point->new(CV_32SC2, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	# my $type_name = Cv::cvTypeOf($seq)->type_name;
	# print STDERR $type_name, "\n";
	# is($typename, "opencv-sequence-tree");

	my @pts = (map { [ $_ * 10 + 1, $_ * 10 + 2 ] } 0 .. 9);
	$seq->Push(@pts);
	ok(equal($seq->GetSeqElem($_), $pts[$_])) for 0 .. $#pts;

	my @arr = $seq->CvtSeqToArray;
	ok(equal($arr[$_], $pts[$_])) for 0 .. $#pts;

	$seq->cvtSeqToArray(\@arr);
	ok(equal($arr[$_], $pts[$_])) for 0 .. $#pts;

	my $arr = [@$seq];
	ok(equal($arr->[$_], $pts[$_])) for 0 .. $#pts;

	my $slice2 = [ 2, 5 ];
	my @arr2 = $seq->ToArray([], $slice2);
	my @pts2 = map { $pts[$_] } $slice2->[0] .. $slice2->[1] - 1;
	ok(equal($arr2[$_], $pts2[$_])) for 0 .. $#pts2;

	$seq->ToArray(\@arr2, $slice2);
	ok(equal($arr2[$_], $pts2[$_])) for 0 .. $#pts2;

	my $arr2 = $seq->toArray([], $slice2);
	ok(equal($arr2->[$_], $pts2[$_])) for 0 .. $#pts2;

	my $slice3 = [ 3, 7 ];
	my @arr3 = $seq->toArray($slice3);
	my @pts3 = map { $pts[$_] } $slice3->[0] .. $slice3->[1] - 1;
	ok(equal($arr3[$_], $pts3[$_])) for 0 .. $#pts3;

	my $arr3 = $seq->toArray($slice3);
	ok(equal($arr3->[$_], $pts3[$_])) for 0 .. $#pts3;

	# overload
	@arr = @$seq;
	ok(equal($arr[$_], $pts[$_])) for 0 .. $#pts;
}


if (3) {
	my $stor = Cv::MemStorage->new;
	ok($stor->isa('Cv::MemStorage'));
	my $seq = Cv::Seq::Point->new(CV_32SC2, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	$seq->Push([0, 1], [2, 3]);
	is($seq->total, 2);

	my $p = $seq->Shift;
	ok(equal($p, [0, 1]));

	my $q = $seq->Shift;
	ok(equal($q, [2, 3]));
}


if (4) {
	my $stor = new Cv::MemStorage;
	ok($stor->isa('Cv::MemStorage'));
	my $seq = new Cv::Seq::Point(CV_32SC2, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	$seq->Unshift([0, 1], [2, 3]);
	is($seq->total, 2);

	my $p = $seq->Pop;
	ok(equal($p, [0, 1]));

	my $q = $seq->Pop;
	ok(equal($q, [2, 3]));
}


if (5) {
	my $stor = Cv::MemStorage->new;
	ok($stor->isa('Cv::MemStorage'));
	my $seq = Cv::Seq::Point->new(CV_32SC2, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	$seq->Push([1, 1], [2, 2]);
	is($seq->total, 2);

	my @arr = $seq->Splice(1, 1);
	is($seq->total, 1);
	ok(equal($arr[0], [2, 2]));

	$seq->Push([2, 2], [3, 3]);
	is($seq->total, 3);

	$seq->Splice(1);
	is($seq->total, 1);

	$seq->Splice(0);
	is($seq->total, 0);

	$seq->Push([1, 1], [2, 2], [3, 3]);
	is($seq->total, 3);

	$seq->Splice(1, 1, [4, 4], [5, 5]);
	is($seq->total, 4);
}

if (6) {
	my $stor = Cv::MemStorage->new;
	ok($stor->isa('Cv::MemStorage'));
	my $seq = Cv::Seq::Point->new(CV_32SC2, $stor);
	ok($seq->isa('Cv::Seq::Point'));

	$seq->Push([1, 1], [2, 2]);
	is($seq->total, 2);
	my $p0 = $seq->Get(0);
	is($p0->[0], 1);

	$seq->Set(0, [3, 3]);
	my $p1 = $seq->Get(0);
	is($p1->[0], 3);

}
