# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=head1 NAME

Cv - helps you to make something around computer vision.

=head1 SYNOPSIS

 use Cv;
 
 my $image = Cv->LoadImage("/path/to/image", CV_LOAD_IMAGE_COLOR);
 $image->ShowImage("image");
 Cv->WaitKey;
 
 my $capture = Cv->CaptureFromCAM(0);
 while (my $frame = $capture->QueryFrame) {
   $frame->Flip(\0, 1)->ShowImage;
   my $c = Cv->WaitKey(100);
   last if $c >= 0;
 }

=head1 DESCRIPTION

C<Cv> is the Perl interface to the OpenCV computer vision library that
originally developed by Intel.  I'm making this module to use the
computer vision more easily like a slogan of perl I<"Easy things
should be easy, hard things should be possible.">

The features are as follows.

=cut

package Cv;

use 5.008008;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);

our $VERSION = '0.16';

use Cv::Constant qw(:all);

require XSLoader;
XSLoader::load('Cv', $VERSION);

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT_MISC = grep { Cv->UNIVERSAL::can($_) } ( qw( cvCbrt cvCeil
	cvFastArctan cvFloor cvMSERParams cvPoint cvPoint2D32f
	cvPointTo32f cvPoint3D32f cvPoint2D64f cvPointTo64f cvPoint3D64f
	cvRealScalar cvRect cvRound cvSURFParams cvScalar cvScalarAll
	cvSize cvSize2D32f cvSlice cvSqrt cvTermCriteria cvVersion ) );

our %EXPORT_TAGS = (
	'all' => [ (grep /^(IPL|CV|cv)/, keys %Cv::) ],
	'std' => [ (grep /^(IPL|CV)/, keys %Cv::), @EXPORT_MISC ],
	);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( );

sub import {
	my $self = shift;
	my @std = ();
	my %auto = (
		more => 'Cv::More',
		seq => 'Cv::Seq',
		);
	for (@_) {
		if (/^:no(\w+)$/) {
			delete $auto{lc $1};
		} else {
			push(@std, $_);
		}
	}
	eval "use $auto{$_}" for
		grep { defined $auto{$_} } qw(seq more);
	push(@std, ":std") unless @std;
	$self->export_to_level(1, $self, @std);
}

sub DESTROY { }

sub CV_MAJOR_VERSION () { ${[ &CV_VERSION ]}[0] }
sub CV_MINOR_VERSION () { ${[ &CV_VERSION ]}[1] }
sub CV_SUBMINOR_VERSION () { ${[ &CV_VERSION ]}[2] }

Cv::alias(qw(Version));

# use Cv::Seq;

=over 4

=item *

C<Cv> was made along the online reference manual of C in the OpenCV
documentation.  For details, please refer to the
http://opencv.willowgarage.com/.

=item *

You can use C<CreateSomething()> as a constructors. 

 my $img = Cv->CreateImage([ 320, 240 ], IPL_DEPTH_8U, 3);
 my $mat = Cv->CreateMat([ 240, 320 ], CV_8UC3);

=item *

You can also use C<new> as a constructor.  C<Cv::Image-E<gt>new> is
C<Cv-E<gt>CreateImage()>, C<Cv::Mat-E<gt>new> is
C<Cv-E<gt>CreateMat()>.  In the calling parameters, there are some
difference in CreateImage() and CreateMat().  But there are no
difference in C<Cv::Something-E<gt>new>.  This is because we create
same object without knowing about original object in the C<Cv::Arr>.

 my $img = Cv::Image->new([ 240, 320 ], CV_8UC3);
 my $mat = Cv::Mat->new([ 240, 320 ], CV_8UC4);

You can omit parameters and that will be inherited.

 my $sameone = $img->new;
 my $gray = $color->new(CV_8UC1);

=cut

sub Cv::Image::new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	my ($channels, $depth) = (&Cv::CV_MAT_CN($type), &Cv::CV2IPL_DEPTH($type));
	Carp::croak "usage: Cv::Image->new(sizes, type)" unless $depth;
	my $image;
	my ($rows, $cols) = @$sizes;
	if (@_) {
		$image = Cv::cvCreateImageHeader([$cols, $rows], $depth, $channels);
		$image->setData($_[0], &Cv::CV_AUTOSTEP) if $_[0];
	} else {
		$image = Cv::cvCreateImage([$cols, $rows], $depth, $channels);
	}
	$image->origin($self->origin) if ref $self;
	$image;
}


sub Cv::Mat::new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	my ($rows, $cols) = @$sizes; $cols ||= 1;
	if (@_) {
		my ($data, $step) = @_; $step ||= &Cv::CV_AUTOSTEP;
		my $mat = Cv::cvCreateMatHeader($rows, $cols, $type);
		$mat->setData($data, $step) if $data;
		$mat;
	} else {
		Cv::cvCreateMat($rows, $cols, $type);
	}
}


sub Cv::MatND::new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	if (@_) {
		my $mat = Cv::cvCreateMatNDHeader($sizes, $type);
		$mat->setData($_[0], &Cv::CV_AUTOSTEP) if $_[0];
		$mat;
	} else {
		Cv::cvCreateMatND($sizes, $type);
	}
}


sub Cv::SparseMat::new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	unshift(@_, $sizes, $type);
	goto &Cv::cvCreateSparseMat;
}


=item *

You have to call cvReleaseImage() when you'll destroy the image object
in the OpenCV application programs.  But in the C<Cv>, you don't have
to call cvReleaseImage() because Perl calls C<DESTROY> for cleanup.
So the subroutine C<DESTROY> has often been defined as an alias of
cvReleaseImage(), cvReleaseMat(), ... and cvReleaseSomething().

Some functions, eg. cvQueryFrame() return a reference but that cannot
be destroyed. In this case, the reference is blessed with
C<Cv::Somthing::Ghost>, and identified. And disable destroying.

=cut

package Cv::Arr;                                            sub DESTROY {}
package Cv::Mat;              our @ISA = qw(Cv::Arr);
package Cv::Mat::Ghost;       our @ISA = qw(Cv::Mat);       sub DESTROY {}
package Cv::MatND;            our @ISA = qw(Cv::Mat);
package Cv::MatND::Ghost;     our @ISA = qw(Cv::MatND);     sub DESTROY {}
package Cv::SparseMat;        our @ISA = qw(Cv::MatND);
package Cv::SparseMat::Ghost; our @ISA = qw(Cv::SparseMat); sub DESTROY {}
package Cv::Image;            our @ISA = qw(Cv::Mat);
package Cv::Image::Ghost;     our @ISA = qw(Cv::Image);     sub DESTROY {}
package Cv::Seq;              our @ISA = qw(Cv::Arr);
package Cv::Seq::Seq;         our @ISA = qw(Cv::Seq);
package Cv::ContourScanner;   our @ISA = qw(Cv::Seq);

=item *

You can use name of method, omitting "cv" from the OpenCV function
name, and also use lowercase name beginning. For example, you can call
C<cvCreateMat()> as:

 my $mat = Cv->CreateMat(240, 320, CV_8UC3);
 my $mat = Cv->createMat(240, 320, CV_8UC3);

=cut

package Cv;

foreach (classes('Cv')) {
	next if /::Ghost$/;
	next if /^Cv::Constant$/;
	no warnings 'redefine';
	eval "{ package $_; sub AUTOLOAD { &Cv::autoload } }";
}


sub autoload {
	my ($package, $filename, $line) = caller;
	my $autoload = "${package}::AUTOLOAD";
	my ($package1, $filename1, $line1) = caller(1);
	my $at = "at $filename1 line $line1";
	no strict "refs";
    (my $short = $$autoload) =~ s/.*:://;
	if (my $code = assoc($package, $short)) {
		*$$autoload = $code;
		goto &$$autoload;
	} elsif ($short =~ /^assoc$/) {
		*$$autoload = \&Cv::assoc;
		goto &$$autoload;
	}
	die "${package}::AUTOLOAD can't call $$autoload $at.\n";
}


sub classes {
	my @list = ();
	my $name = shift;
	my $class = eval "\\%${name}::";
	if (ref $class eq 'HASH') {
		for (keys %$class) {
			if (/^(\w+)::$/) {
				push(@list, &classes("${name}::$1"));
			}
		}
		push(@list, $name);
	}
	@list;
}


sub assoc {
	my $family = shift;
	my $short = shift;
	my @names;
	my $verbose = 0;
	# my $verbose = $short =~ /new/i;
	if ($short =~ /^[a-z]/ && $short !~ /^cv[A-Zm]/) {
		(my $caps = $short) =~ s/^[a-z]/\U$&/;
		push(@names, $caps);
		(my $upper = $short) =~ s/^[a-z]+/\U$&/;
		push(@names, $upper) if $caps ne $upper;
		push(@names, map { "cv$_" } @names);
	} else {
		push(@names, "cv$short");
	}
	push(@names, $short);
	foreach (@names) {
		no strict 'refs';
		if (my $subr = $family->UNIVERSAL::can($_)) {
			print STDERR "assoc: found $_ in $family\n" if $verbose;
			if ($family eq 'Cv' && $_ =~ /^cv[A-Zm]/) {
				return sub {
					# shift unless defined $_[0] && ref $_[0] && blessed $_[0];
					ref (my $class = shift) and Carp::croak 'class name needed';
					goto &$subr;
				};
			}
			return $subr;
		}
		print STDERR "assoc: can't $_ in $family\n" if $verbose;
	}
	return undef;
}


sub alias {
	return undef unless @_;
	shift if $_[0] eq __PACKAGE__;
	# my $package = shift;
	my ($package, $filename, $line) = caller;
	my $subr; $subr = pop if (ref $_[-1] eq 'CODE');
	$subr ||= $package->UNIVERSAL::can($_[0]);
	unless ($subr) {
		if (my $code = assoc($package, $_[0])) {
			$subr = $code;
		} else {
			# warn "can't alias ${package}::$_[0]";
			$subr = sub { Carp::croak "TBD: ${package}::$_[0]" };
		}
	}
	my $verbose = 0;
	for my $upper (@_) {
		(my $lower = $upper) =~ s/^[A-Z]+/\L$&/;
		for ($upper, $lower) {
			no strict 'refs';
			unless ($package->UNIVERSAL::can($_)) {
				print STDERR "Cv::alias *{${package}::$_}\n" if $verbose;
				*{"${package}::$_"} = $subr;
			}
		}
	}
	$subr;
}

=item *

When you omit the destination image or matrix (often named "dst"),
C<Cv> creates new destination if possible.

 my $dst = $src->Add($src2);
 my $dst = $src->Add($src2, $mask);  # can't omit dst

in this case, you can create $dst as follows:

 my $dst = $src->Add($src2, $src->new, $mask); 

=item *

Some functions in the OpenCV can handle inplace that use source image
as destination one. To tell requesting inplace, you can use C<\0> as
C<NULL> for the destination.

 my $dst = $src->Flip(\0);

=cut

package Cv;

sub is_null { ref $_[0] eq 'SCALAR' && ${$_[0]} == 0 }
sub is_cvarr { blessed $_[0] && $_[0]->isa('Cv::Arr') }


# ============================================================
#  core. The Core Functionality: Operations on Arrays
# ============================================================

package Cv::Arr;

# The GetDims needs alias before calling.  The function called via
# AUTOLOAD will not know the context of the caller.

Cv::alias qw(GetDims);
Cv::alias qw(Size), \&cvGetSize;

sub dst (\@) {
	my $dst = undef;
	for (my $i = 0; $i < @{$_[0]}; $i++) {
		($dst) = splice(@{$_[0]}, $i, 1), last
			if Cv::is_cvarr(${$_[0]}[$i])
			|| $i == 0 && Cv::is_null(${$_[0]}[$i]);
	}
	$dst;
}

=item *

The members of structure are same as function.

 my ($c, $d) = ($img->channels, $img->depth);
 my ($h, $w) = ($img->height, $img->width);
 my ($r, $c) = ($img->rows, $img->cols);
 my @sz = $img->sizes;

But we can't use as lvalue.

 my $roi = $img->roi;              # GetImageROI($img)
 $img->roi($roi);                  # SetImageROI($img, $roi)
 my $coi = $img->coi;              # GetImageCOI($img)
 $img->coi($coi);                  # SetImageCOI($img, $coi)

=cut

sub ROI {
	my $self = shift;
	my $roi = cvGetImageROI($self);
	cvSetImageROI($self, @_) if @_;
	$roi;
}

sub COI {
	my $self = shift;
	my $coi = cvGetImageCOI($self);
	cvSetImageCOI($self, @_) if @_;
	$coi;
}


=item *

There are functions Get() and Set(). They access an elements.  You can
call Get() as cvGetND(), and Set() as cvSetND().  So, you have to to
call Fill() instead of calling the cvSetND().

 my $x = $mat->Get($i, $j);        # cvGetND($mat, [$i, $j])
 my $x = $mat->Get(\@idx);         # cvGetND($mat, \@idx);

When the number of indexes is less than the number of the dimensions,
0 is complemented as indexes.  

 $mat->Set([$i, $j, ...], $x);     # cvSetND($mat, [$i, $j, ...], $x)
 $mat->Set(\@idx, $x);             # cvSetND($mat, \@idx, $x)
 $mat->Fill($x);                   # cvSet($mat, $x)

=cut

{ *Get = \&GetND }
sub GetND {
	# Get($src, $idx0);
	# Get($src, $idx0, $idx1);
	# Get($src, $idx0, $idx1, $idx2);
	# Get($src, $idx0, $idx1, $idx2, $idx3);
	# Get($src, \@idx);
	my $src = shift;
	my $idx = ref $_[0] eq 'ARRAY'? shift : [ splice(@_, 0) ];
	push(@$idx, (0) x ($src->dims - @$idx));
	unshift(@_, $src, $idx);
	goto &cvGetND;
}

{ *Set = *set = \&SetND }
sub SetND {
	# Set($src, $idx0, $value);
	# Set($src, $idx0, $idx1, $value);
	# Set($src, $idx0, $idx1, $idx2, $value);
	# Set($src, $idx0, $idx1, $idx2, $idx3, $value);
	# Set($src, \@idx, $value);
	my $src = shift;
	my $value = pop;
	my $idx = ref $_[0] eq 'ARRAY'? shift : [ splice(@_, 0) ];
	push(@$idx, (0) x ($src->dims - @$idx));
	unshift(@_, $src, $idx, $value);
	goto &cvSetND;
}


sub GetReal {
	# GetReal($src, $idx0);
	# GetReal($src, $idx0, $idx1);
	# GetReal($src, $idx0, $idx1, $idx2);
	# GetReal($src, $idx0, $idx1, $idx2, $idx3);
	# GetReal($src, [$idx0, $idx1, $idx2, $idx3]);
	my $src = shift;
	my $idx = ref $_[0] eq 'ARRAY'? shift : [ splice(@_, 0) ];
	push(@$idx, (0) x ($src->dims - @$idx));
	unshift(@_, $src, $idx);
	goto &cvGetRealND;
}


sub SetReal {
	# SetReal($src, $idx0, $value);
	# SetReal($src, $idx0, $idx1, $value);
	# SetReal($src, $idx0, $idx1, $idx2, $value);
	# SetReal($src, $idx0, $idx1, $idx2, $idx3, $value);
	# SetReal($src, \@idx, $value);
	my $src = shift;
	my $value = pop;
	my $idx = ref $_[0] eq 'ARRAY'? shift : [ splice(@_, 0) ];
	push(@$idx, (0) x ($src->dims - @$idx));
	unshift(@_, $src, $idx);
	push(@_, $value);
	goto &cvSetRealND;
}


=item *

Ptr() returns a string that from specified element up to the end of
the line.  Parameters are same as Get().

 my $str = $mat->Ptr($row, $col);  # cvPtrND($mat, [$row, $col]);
 my $str = $mat->Ptr($row);        # cvPtrND($mat, [$row]);

=cut

sub Ptr {
	# Ptr($src, $idx0);
	# Ptr($src, $idx0, $idx1);
	# Ptr($src, $idx0, $idx1, $idx2);
	# Ptr($src, $idx0, $idx1, $idx2, $idx3);
	# Ptr($src, \@idx);
	my $src = shift;
	my $idx = ref $_[0] eq 'ARRAY'? shift : [ splice(@_, 0) ];
	push(@$idx, (0) x ($src->dims - @$idx));
	unshift(@_, $src, $idx);
	goto &cvPtrND;
}

=item *

There are functions to split per channel and merge them.

 $rgb->Split($r, $g, $b);          # cvSplit($rgb, $r, $g, $b)
 my ($r, $g, $b) = $rgb->Split;    # cvSplit($rgb, $r, $g, $b)
 my $rgb = Cv->Merge($r, $g, $b);  # cvMerge([$r, $g, $b], $rgb);

=cut

{ *CvtPixToPlane = \&Split }
sub Split {
	# Split(src, $dst0, $dst1, ...);
	my $src = shift;
	unless (@_) {
		for (1 .. $src->channels) {
			my $dst = $src->new(&Cv::CV_MAKETYPE($src->type, 1));
			push(@_, $dst);
		}
	}
	cvSplit($src, @_);
	wantarray ? @_ : \@_;	# XXXXX
}


sub Cv::Merge {
	ref (my $class = CORE::shift) and Carp::croak 'class name needed';
	if (ref $_[0] eq 'ARRAY') {
		Cv::Arr::Merge(@_);
	} elsif (Cv::is_cvarr($_[0])) {
		if (@_ <= 4) {
			Cv::Arr::Merge(\@_);
		} else {
			my $dst = pop(@_);
			Cv::Arr::Merge(\@_, $dst);
		}
	} else {
		Carp::croak "usage: Merge([src0, src1, ...], dst)"
	}
}


sub Merge {
	# Merge([src1, src2, ...], [dst]);
	my $srcs = shift;
	my $dst = shift;
	unless ($dst) {
		my $src0 = $srcs->[0];
		$dst = $src0->new(&Cv::CV_MAKETYPE($src0->type, scalar @$srcs));
	}
	unshift(@_, $srcs, $dst);
	goto &Cv::cvMerge;
}


# The following functions call the CreatelSomethingHeader() if $submat
# is not given.
#
#  my $submat = $src->GetCols($startCol, $endCol);
#  my $submat = $src->GetRows($startRow, $endRow, $deltaRow);
#  my $submat = $src->GetSubRect($rect);

{ *GetCol = \&GetCols }
sub GetCols {
	# GetCols($src, [$submat], $col);
	# GetCols($src, [$submat], $startCol, $endCol);
	my $src = shift;
	my $submat = dst(@_);
	push(@_, 0, $src->cols) if @_ == 0;
	push(@_, $_[-1] + 1) if @_ == 1;
	my $startCol = shift;
	my $endCol  = shift;
	my $cols = $endCol - $startCol;
	$submat ||= Cv::Mat->new([$src->rows, $cols], $src->type, undef);
	unshift(@_, $src, $submat, $startCol, $endCol);
	goto &cvGetCols;
}


{ *GetRow = \&GetRows }
sub GetRows {
	# GetRows($src, [$submat], $row);
	# GetRows($src, [$submat], $startRow, $endRow, [$deltaRow]);
	my $src = shift;
	my $submat = dst(@_);
	push(@_, 0, $src->rows) if @_ == 0;
	push(@_, $_[-1] + 1) if @_ == 1;
	my $startRow = shift;
	my $endRow = shift;
	my $deltaRow = shift || 1;
	my $rows = int(($endRow - $startRow) / $deltaRow);
	$submat ||= Cv::Mat->new([$rows, $src->cols], $src->type, undef);
	unshift(@_, $src, $submat, $startRow, $endRow, $deltaRow);
	goto &cvGetRows;
}


sub GetSubRect {
	# GetSubRect($src, [$submat], $rect);
	my $src = shift;
	my $submat = dst(@_);
	my $rect = shift || [ 0, 0, $src->width, $src->height ];
	my $sizes = [ $rect->[3], $rect->[2] ];
	$submat ||= Cv::Mat->new($sizes, $src->type, undef);
	unshift(@_, $src, $submat, $rect);
	goto &cvGetSubRect;
}


=item *

cvAddS() and cvAdd() are integrated into Add().  The function which
can be identified by the argument.

 my $ar2 = Cv->CreateImage();      # ref Cv::Image
 my $sc2 = cvScalar();             # ref ARRAY
 my $d = $ar->Add($ar2);           # cvAdd($ar, $ar2)
 my $d = $ar->Add($sc2);           # cvAddS($ar, $sc2)

The integrated function as follows.

 AbsDiff(), Add(), And(), Cmp(), InRange(), Max(), Min(), Or(), Sub(),
 Xor()

=cut

{ *AbsDiffS = \&AbsDiff }
sub AbsDiff {
	# AbsDiff(src1, src2, [dst])
	# AbsDiffS(src, value, [dst])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvAbsDiffS;
		# goto &{*cvAbsDiffS{CODE}};
	} else {
		goto &cvAbsDiff;
		# goto &{*cvAbsDiff{CODE}};
	}
}


{ *AddS = \&Add }
sub Add {
	# Add(src1, src2, [dst], [mask])
	# AddS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvAddS;
	} else {
		goto &cvAdd;
	}
}

{ *AndS = \&And }
sub And {
	# And(src1, src2, [dst], [mask])
	# AndS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvAndS;
	} else {
		goto &cvAnd;
	}
}


{ *CmpS = \&Cmp }
sub Cmp {
	# Cmp(src, src2, [dst], cmpOp)
	# CmpS(src, value, [dst], cmpOp)
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new(&Cv::CV_8UC(&Cv::CV_MAT_CN($src->type)));
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvCmpS;
	} else {
		goto &cvCmp;
	}
}


{ *InRangeS = \&InRange }
sub InRange {
	# InRange($src, $upper, $lower, [$dst]);
	# InRangeS($src, $upper, $lower, [$dst]);
	my $src = shift;
	my ($upper, $lower) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $upper, $lower, $dst);
	if (ref $upper eq 'ARRAY') {
		goto &cvInRangeS;
	} else {
		goto &cvInRange;
	}
}


{ *MaxS = \&Max }
sub Max {
	# Max(src1, src2, [dst]);
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvMaxS;
	} else {
		goto &cvMax;
	}
}


{ *MinS = \&Min }
sub Min {
	# Min(src1, src2, [dst]);
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvMinS;
	} else {
		goto &cvMin;
	}
}


{ *OrS = \&Or }
sub Or {
	# Or(src1, src2, [dst], [mask])
	# OrS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvOrS;
	} else {
		goto &cvOr;
	}
}


{ *SubS = \&Sub }
sub Sub {
	# Sub(src1, src2, [dst], [mask])
	# SubS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvSubS;
	} else {
		goto &cvSub;
	}
}


{ *XorS = \&Xor }
sub Xor {
	# Xor(src1, src2, [dst], [mask])
	# XorS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvXorS;
		# goto &{*cvXorS{CODE}};
	} else {
		goto &cvXor;
		# goto &{*cvXor{CODE}};
	}
}


{ *Scale = *Convert = *CvtScale = \&ConvertScale }
sub ConvertScale {
	# ConvertScale(src, [dst], [scale], [shift])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvConvertScale;
}


{ *CvtScaleAbs = \&ConvertScaleAbs }
sub ConvertScaleAbs {
	# ConvertScaleAbs(src, [dst], [scale], [shift])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvConvertScaleAbs;
}


sub AddWeighted {
	# AddWeighted(src1, alpha, src2, beta, gamma, [dst])
	my ($src, $alpha, $src2, $beta, $gamma) = splice(@_, 0, 5);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $alpha, $src2, $beta, $gamma, $dst);
	goto &cvAddWeighted;
}


sub CrossProduct {
	# CrossProduct(src1, src2, [dst])
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvCrossProduct;
}


sub DCT {
	# DCT(src, [dst], flags)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDCT;
}


sub DFT {
	# DFT(src, [dst], flags, [nonzeroRows])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDFT;
}


sub Div {
	# Div(src1, src2, [dst], [scale]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvDiv;
}


sub Exp {
	# Exp(src, [dst]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvExp;
}


{ *Mirror = \&Flip }
sub Flip {
	# Flip(src, [dst], flipMode)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvFlip;
}


sub GEMM {
	# GEMM($src, $src2, $alpha, $src3, $beta, [$dst], [$tABC]);
	my ($src, $src2, $alpha, $src3, $beta) = splice(@_, 0, 5);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $alpha, $src3, $beta, $dst);
	goto &cvGEMM;
}


sub MatMulAdd {
	# MatMulAdd($src1, $src2, $src3, [$dst]);
	my ($src, $src2, $src3) = splice(@_, 0, 3);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, 1, $src3, 1, $dst, 0);
	goto &GEMM;
}


sub MatMul {
	# MatMulAdd($src1, $src2, [$dst]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, \0, $dst);
	goto &MatMulAdd;
}


sub Inv {
	# Inv(src, [dst], [$method]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvInv;
}


sub Log {
	# Log(src, [dst]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvLog;
}


sub LUT {
	# LUT(src, [dst], $lut);
	my $src = shift;
	my $lut = pop;
	my $dst = dst(@_);
	if (&Cv::CV_MAT_CN($lut->type) > 1) {
		my @lut = $lut->split;
		$dst ||= $src->new($lut->type);
		my @dsts = $dst->split;
		cvLUT($src, $dsts[$_], $lut[$_]) for 0 .. $#lut;
		Cv->Merge(\@dsts, $dst); # XXXXX
	} else {
		$dst ||= $src->new(&Cv::CV_MAKETYPE($lut->type, 1));
		unshift(@_, $src, $dst, $lut);
		goto &cvLUT;
	}
}


sub Mul {
	# Mul(src1, src2, [dst], [scale])
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvMul;
}


sub MulSpectrums {
	# MulSpectrums(src1, src2, [dst], flags);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvMulSpectrums;
}


sub MulTransposed {
	# MulTransposed(src1, src2, [dst], order, [delta], [scale]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvMulTransposed;
}


sub Normalize {
	# Normalize(src, dst, [a], [b], [norm_type], [mask])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvNormalize;
}


sub Not {
	# Not(src, [dst])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvNot;
}


sub Pow {
	# Pow(src, [dst], power)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvPow;
}


sub Reduce {
	# Reduce(src, [dst], [dim], [op]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvReduce;
}


sub Repeat {
	# Repeat(src, dst);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvRepeat;
}


{ *MulAddS = \&ScaleAdd }
sub ScaleAdd {
	# ScaleAdd(src, scale, src2, [dst]);
	my ($src, $scale, $src2) = splice(@_, 0, 3);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $scale, $src2, $dst);
	goto &cvScaleAdd;
}


sub SubRS {
	# SubRS(src, value, [dst], [mask])
	my ($src, $value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $value, $dst);
	goto &cvSubRS;
}


sub Transpose {
	# Transpose(src, [dst])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvTranspose;
}


# package Cv::Image; Cv::alias qw(InitImageHeader);
# package Cv::Mat; Cv::alias qw(InitMatHeader);
# package Cv::MatND; Cv::alias qw(InitMatNDHeader);
# package Cv::SparseMat; Cv::alias qw(InitSparseMatIterator);

=pod

=back

=cut

# ============================================================
#  core. The Core Functionality: Dynamic Structures
# ============================================================

package Cv;

sub is_cvmem { blessed $_[0] && $_[0]->isa('Cv::MemStorage') }

package Cv::MemStorage;
{ *new = \&Cv::CreateMemStorage }


# ============================================================
#  core. The Core Functionality: Drawing Functions
# ============================================================

package Cv;

sub CV_RGB { my ($r, $g, $b, $a) = @_; cvScalar($b, $g, $r, $a || 0) }

package Cv::Font;
{ *new = \&Cv::InitFont }


# ============================================================
#  core. The Core Functionality: XML/YAML Persistence
# ============================================================

package Cv;

our %TYPENAME2CLASS;

for ([ qw(CV_TYPE_NAME_GRAPH Cv::Graph) ],
	 [ qw(CV_TYPE_NAME_HAAR Cv::HaarClassifierCascade) ],
	 [ qw(CV_TYPE_NAME_IMAGE Cv::Image) ],
	 [ qw(CV_TYPE_NAME_MAT Cv::Mat) ],
	 [ qw(CV_TYPE_NAME_MATND Cv::MatND) ],
	 [ qw(CV_TYPE_NAME_SEQ Cv::Seq) ],
	 [ qw(CV_TYPE_NAME_SEQ_TREE Cv::Seq) ],
	 [ qw(CV_TYPE_NAME_SPARSE_MAT Cv::SparseMat) ]) {
	next unless my $t = eval $_->[0];
	$TYPENAME2CLASS{$t} = $_->[1];
}

package Cv::FileStorage;
{ *new = \&Cv::OpenFileStorage }

sub fsbless {
	my $ptr = shift;
	if ($ptr) {
		if (my $info = Cv::cvTypeOf($ptr)) {
			if (my $class = $Cv::TYPENAME2CLASS{$info->type_name}) {
				bless $ptr, $class;
			}
		}
	}
	$ptr;
}


sub Cv::Load {
	ref (my $class = CORE::shift) and Carp::croak 'class name needed';
	Cv::FileStorage->Load(@_)
}


sub Load {
	ref (my $class = CORE::shift) and Carp::croak 'class name needed';
	fsbless Cv::cvLoad(@_);
}


sub Read {
	fsbless cvRead(@_);
}

sub ReadByName {
	my ($fs, $map, $name) = splice(@_, 0, 3);
	Carp::croak "instance variable needed" unless ref $fs;
	$fs->Read($fs->getFileNodeByName($map, $name), @_);
}

sub Cv::TypeInfo::DESTROY {}
sub Cv::FileNode::DESTROY {}
sub Cv::String::DESTROY {}

# ============================================================
#  core. The Core Functionality: Clustering
# ============================================================

# ============================================================
#  core. The Core Functionality: Utility and System Functions and Macros
# ============================================================

package Cv;

=head2 Error Handling

C<Cv> is now possible to detect errors that occur in the block
protected as eval { ... }. (Cv-0.13)

 my $img = eval { Cv->createImage([-1, -1], 8, 3) };
 if ($@) {
    print STDERR "*** got error ***";
 }

But, when you build Cv you have to compile with c++.  You can catch
the error, and you can also redirect to your own error hander.

 Cv->redirectError(
   sub { my ($status, $funcName, $errMsg, $fileName, $line, $data) = @_;
       ...
   },
   my $data = ...;
 );

=cut


# ============================================================
#  imgproc. Image Processing: Histograms
# ============================================================

package Cv::Histogram;

sub new {
	my $self = shift;
	my $sizes = @_? shift : $self->sizes;
	my $type = @_? shift : &Cv::CV_HIST_ARRAY;
	my $ranges = @_? shift : $self->thresh;
	unshift(@_, $sizes, $type, $ranges);
	goto &Cv::cvCreateHist;
}


{ *Copy = \&CopyHist }
sub CopyHist {
	# CopyHist(src. dst)
	my $src = shift;
	my $dst = shift || $src->new;
	unshift(@_, $src, $dst);
	goto &cvCopyHist;
}


sub GetHistValue {
	my $self = shift;
	my $arr = $self->bins->Ptr(@_);
	my @floats = unpack("f*", $arr);
	wantarray? @floats : \@floats;
}


sub QueryHistValue {
	my $self = shift;
	$self->bins->GetReal(@_);
}

{ *Calc = \&CalcHist }
{ *Clear = \&ClearHist }
{ *Compare = \&CompareHist }
{ *Normalize = \&NormalizeHist }
{ *SetBinRanges = \&SetHistBinRanges }
{ *Thresh = \&ThreshHist }


# ============================================================
#  imgproc. Image Processing: Image Filtering
# ============================================================

package Cv::Arr;

sub CopyMakeBorder {
	# CopyMakeBorder(src, dst, offset, bordertype, [value]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvCopyMakeBorder;
}


sub Dilate {
	# Dilate(src, dst, [element], [iterations])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDilate;
}


sub Erode {
	# Erode(src, dst, [element], [iterations])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvErode;
}


sub Filter2D {
	# Filter2D(src, dst, [kernel], [anchor])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvFilter2D;
}


sub Laplace {
	# Laplace(src, dst, [apertureSize])
	my $src = shift;
	my $dst = dst(@_) || $src->new(&Cv::CV_16SC(&Cv::CV_MAT_CN($src->type)));
	unshift(@_, $src, $dst);
	goto &cvLaplace;
}


sub MorphologyEx {
	# MorphologyEx(src, dst, temp, element, operation, [iterations])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	if (@_) {
		my $temp = dst(@_);
		if (@_) {
			my $element = shift;
			if (@_) {
				my $operation = shift;
				if ($operation == &Cv::CV_MOP_TOPHAT ||
					$operation == &Cv::CV_MOP_BLACKHAT) {
					$temp ||= $src->new;
				}
				unshift(@_, $operation);
			}
			unshift(@_, $element);
		}
		unshift(@_, $temp);
	}
	unshift(@_, $src, $dst);
	goto &cvMorphologyEx;
}


sub PyrDown {
	# PyrDown(src, dst, [filter]);
	my $src = shift;
	my $dst = dst(@_) || $src->new([map { int(($_ + 1) / 2) } @{$src->sizes}]);
	unshift(@_, $src, $dst);
	goto &cvPyrDown;
}


sub PyrUp {
	# PyrUp(src, dst, [filter]);
	my $src = shift;
	my $dst = dst(@_) || $src->new([map { int($_ * 2) } @{$src->sizes}]);
	unshift(@_, $src, $dst);
	goto &cvPyrUp;
}


sub Smooth {
	# Smooth(src, dst, [smoothtype], [param1], [param2], [param3], [param4])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvSmooth;
}


sub Sobel {
	# Sobel(src, dst, xorder, yorder, [apertureSize])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvSobel;
}


package Cv::ConvKernel;
{ *new = \&Cv::CreateStructuringElementEx }


# ============================================================
#  imgproc. Image Processing: Geometric Image Transformations
# ============================================================

package Cv;

sub GetRotationMatrix2D {
	my ($class, $center, $angle, $scale, $map) = splice(@_, 0, 5);
	$map ||= Cv::Mat->new([2, 3], &Cv::CV_32FC1);
	unshift(@_, $center, $angle, $scale, $map);
	goto &cv2DRotationMatrix;
}


sub GetAffineTransform {
	my ($class, $src, $dst, $map) = splice(@_, 0, 4);
	$map ||= Cv::Mat->new([2, 3], &Cv::CV_32FC1);
	unshift(@_, $src, $dst, $map);
	goto &cvGetAffineTransform;
}


sub GetPerspectiveTransform {
	my ($class, $src, $dst, $map) = splice(@_, 0, 4);
	$map ||= Cv::Mat->new([3, 3], &Cv::CV_32FC1);
	unshift(@_, $src, $dst, $map);
	goto &cvGetPerspectiveTransform;
}


package Cv::Arr;

sub GetQuadrangleSubPix {
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvGetQuadrangleSubPix;
}

sub LinearPolar {
	# LinearPolar(src, dst, center, maxRadius, [flags]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvLinearPolar;
}


sub LogPolar {
	# LogPolar(src, dst, center, M, [flags]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvLogPolar;
}


sub Remap {
	# Remap(src, dst, mapx, mapy, [flags], [fillval])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvRemap;
}


sub Resize {
	# Resize(src, dst, [interpolation])
	my $src = shift;
	my $dst;
	if (@_ && ref $_[0] eq 'ARRAY') {
		my $sizes = shift;
		$dst = $src->new($sizes);
	} else {
		$dst = dst(@_) || $src->new;
	}
	unshift(@_, $src, $dst);
	goto &cvResize;
}


sub WarpAffine {
	# WarpAffine(src, dst, mapMatrix, [flags], [fillval])
	my ($src, $dst, $map) = splice(@_, 0, 3);
	unless (ref $map) {
		unshift(@_, $map);
		($dst, $map) = (undef, $dst);
	}
	$dst ||= $src->new;
	unshift(@_, $src, $dst, $map);
	goto &cvWarpAffine;
}


sub WarpPerspective {
	# WarpPerspective(src, dst, mapMatrix, [flags], [fillval])
	my ($src, $dst, $map) = splice(@_, 0, 3);
	unless (ref $map) {
		unshift(@_, $map);
		($dst, $map) = (undef, $dst);
	}
	$dst ||= $src->new;
	unshift(@_, $src, $dst, $map);
	goto &cvWarpPerspective;
}

# ============================================================
#  imgproc. Image Processing: Miscellaneous Image Transformations
# ============================================================

package Cv::Arr;

sub AdaptiveThreshold {
	# AdaptiveThreshold(src, dst, maxValue, [adaptive_method], [thresholdType], [blockSize], [param1])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvAdaptiveThreshold;
}

sub CvtColor {
	# cvtColor(src, [dst], code)
	# cvtColor(src, code, [dst])
	my $src = shift;
	my $dst = dst(@_);
	my $code = shift;
	unless ($dst) {
		if (!defined $code) {
			Carp::croak "Usage: Cv->CvtColor(src, dst, code)";
		} elsif ($code == &Cv::CV_BGR2GRAY  || $code == &Cv::CV_RGB2GRAY) {
			$dst = $src->new($src->sizes, &Cv::CV_MAKETYPE($src->type, 1));
		} elsif ($code == &Cv::CV_GRAY2BGR  || $code == &Cv::CV_GRAY2RGB  ||
				 $code == &Cv::CV_BGR2HSV   || $code == &Cv::CV_RGB2HSV   ||
				 $code == &Cv::CV_BGR2YCrCb || $code == &Cv::CV_RGB2YCrCb ||
				 $code == &Cv::CV_YCrCb2BGR || $code == &Cv::CV_YCrCb2RGB) {
			$dst = $src->new($src->sizes, &Cv::CV_MAKETYPE($src->type, 3));
		}
	}
	unshift(@_, $src, $dst, $code);
	goto &cvCvtColor;
}


sub DistTransform {
	# DistTransform(src, dst, [distance_type], [mask_size], [mask], [labels]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDistTransform;
}


sub EqualizeHist {
	# EqualizeHist(src, dst)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvEqualizeHist;
}


sub Inpaint {
	# Inpaint(src, mask, dst, inpaintRadius, flags)
	my ($src, $mask) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $mask, $dst);
	goto &cvInpaint;
}


sub Integral {
	# Integral(image, sum, [sqsum], [tiltedSum])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvIntegral;
}


sub PyrMeanShiftFiltering {
	# PyrMeanShiftFiltering(src, dst, sp, sr, [max_level], [termcrit])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvPyrMeanShiftFiltering;
}


sub PyrSegmentation {
	# PyrSegmentation(src, dst, storage, comp, level, threshold1, threshold2)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvPyrSegmentation;
}


sub Threshold {
	# Threshold(src, dst, threshold, maxValue, thresholdType)
	my $src = shift;
	my $dst = dst(@_) || $src->new(&Cv::CV_MAKETYPE($src->type, 1));
	unshift(@_, $src, $dst);
	goto &cvThreshold;
}

# ============================================================
#  imgproc. Image Processing: Structural Analysis and Shape Descriptors
# ============================================================

package Cv;

sub BoxPoints {
	ref (my $class = shift) and Carp::croak 'class name needed';
	cvBoxPoints($_[0], my $pts);
	@{ $_[1] //= [] } = @$pts if @_ >= 2;
	wantarray? @$pts : $pts;
}


# ============================================================
#  imgproc. Image Processing: Planar Subdivisions
# ============================================================

package Cv::Subdiv2D;
sub DESTROY { }
{ *CalcVoronoi = \&CalcSubdivVoronoi2D }
{ *ClearVoronoi = \&ClearSubdivVoronoi2D }
{ *CreateDelaunay = \&Cv::CreateSubdivDelaunay2D }
{ *Locate = \&Subdiv2DLocate }
{ *DelaunayInsert = \&SubdivDelaunay2DInsert }

# ============================================================
#  imgproc. Image Processing: Motion Analysis and Object Tracking
# ============================================================

# ============================================================
#  imgproc. Image Processing: Feature Detection
# ============================================================

package Cv::Arr;

sub Canny {
	# Canny(image, edges, threshold1, threshold2, aperture_size=3)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvCanny;
}


sub CornerEigenValsAndVecs {
	# CornerEigenValsAndVecs(image, eigenvv, blockSize, aperture_size=3)
	my $src = shift;
	my $dst = dst(@_);
	$dst ||= $src->new([$src->rows, $src->cols * 6], &Cv::CV_32FC1);
	unshift(@_, $src, $dst);
	goto &cvCornerEigenValsAndVecs;
}


sub CornerHarris {
	# CornerHarris(image, harris_dst, blockSize, aperture_size=3, k=0.04)
	my $src = shift;
	my $dst = dst(@_) || $src->new(&Cv::CV_32FC1);
	unshift(@_, $src, $dst);
	goto &cvCornerHarris;
}


sub CornerMinEigenVal {
	# CornerMinEigenVal(image, eigenval, blockSize, aperture_size=3)
	my $src = shift;
	my $dst = dst(@_) || $src->new(&Cv::CV_32FC1);
	unshift(@_, $src, $dst);
	goto &cvCornerMinEigenVal;
}


# ============================================================
#  imgproc. Image Processing: Object Detection
# ============================================================

package Cv::Arr;

sub MatchTemplate {
	# MatchTemplate(image, templ, result, method)
	my $image = shift;
	my $templ = shift;
	my $result = dst(@_) || $templ->new(
		[ $image->rows - $templ->rows + 1,
		  $image->cols - $templ->cols + 1 ], &Cv::CV_32FC1);
	unshift(@_, $image, $templ, $result);
	goto &cvMatchTemplate;
}


# ============================================================
#  features2d. Feature Detection and Descriptor Extraction
# ============================================================

# ============================================================
#  flann. Clustering and Search in Multi-Dimensional Spaces
# ============================================================

# ============================================================
#  objdetect. Object Detection
# ============================================================

package Cv::HaarClassifierCascade;
{ *new = \&Cv::LoadHaarClassifierCascade }


# ============================================================
#  video. Video Analysis: Motion Analysis and Object Tracking
# ============================================================

package Cv::Kalman;
{ *new = \&Cv::CreateKalman }
{ *Correct = \&KalmanCorrect }
{ *Predict = \&KalmanPredict }


# ============================================================
#  highgui. High-level GUI and Media I/O: User Interface
# ============================================================

package Cv::Arr;
{ *Show = \&ShowImage }

# ============================================================
#  highgui. High-level GUI and Media I/O: Reading and Writing Images and Video
# ============================================================

package Cv;

sub cvHasGUI {
	if (fork) {
		wait;
		$? == 0;
	} else {
		open(STDERR, ">/dev/null");
		cvNamedWindow("Cv");
		cvDestroyWindow("Cv");
		exit(0);
	}
}

sub cvHasQt { 0 }

package Cv::Image;
{ *Load = \&Cv::LoadImage }

package Cv::Mat;
{ *Load = \&Cv::LoadImageM }

package Cv::Arr;
{ *Save = \&SaveImage }

package Cv::Capture;
{ *FromCAM = \&Cv::CaptureFromCAM }
{ *FromFile = *FromAVI = \&Cv::CaptureFromFile }
{ *GetProperty = \&GetCaptureProperty }
{ *Grab = \&GrabFrame }
{ *Query = \&QueryFrame }
{ *Retrieve = \&RetrieveFrame }
{ *SetProperty = \&SetCaptureProperty }

package Cv::VideoWriter;
{ *new = \&Cv::CreateVideoWriter }


# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

# ============================================================
#  calib3d. Camera Calibration, Pose Estimation and Stereo: Camera
#   Calibration and 3d Reconstruction
# ============================================================

package Cv::Arr;

sub ProjectPoints2 {
	my ($pts3d, $rvec, $tvec, $cmat, $dist, $pts2d) = splice(@_, 0, 6);
	unless ($pts2d) {
		$pts2d = $pts3d->new(&Cv::CV_MAKETYPE($pts3d->type, 2));
	}
	unshift(@_, $pts3d, $rvec, $tvec, $cmat, $dist, $pts2d);
	goto &cvProjectPoints2;
}


package Cv::StereoBMState;

{ *new = \&Cv::CreateStereoBMState }
{ *FindStereoCorrespondence = *FindCorrespondence = \&FindStereoCorrespondenceBM }

package Cv::StereoGCState;

{ *new = \&Cv::CreateStereoGCState }
{ *FindStereoCorrespondence = *FindCorrespondence = \&FindStereoCorrespondenceGC }

package Cv::StereoSGBM;

sub Cv::CreateStereoSGBM {
	ref (my $class = shift) and Carp::croak 'class name needed';
	Cv::StereoSGBM->new(@_);
}

{ *FindStereoCorrespondence = *FindCorrespondence = \&FindStereoCorrespondenceSGBM }


# ============================================================
#  ml. Machine Learning
# ============================================================


# ============================================================
#  xxx. Background/foreground segmentation
# ============================================================

package Cv::BGCodeBookModel;

{ *new = \&Cv::CreateBGCodeBookModel }
{ *Update = \&BGCodeBookUpdate }
{ *Diff = \&BGCodeBookDiff }
{ *ClearStale = \&BGCodeBookClearStale }

1;
__END__

=head2 EXPORT

You put names after use Cv, constants, functions ... to be
imported. (Cv-0.14)

=over 4

=item *

For example, the following two lines to import functions such as
cvScalar() and the constants starting with C<IPL> and C<CV>.

 use Cv qw(:std);
 use Cv;			# considering :std

=item *

For example, the following two lines to import all variables and
functions of Cv.

 use Cv qw(:all);
 use Cv qw(/^(CV|IPL|cv)/);

=item *

If you do not want to import anything, put an empty list.

 use Cv qw( );

=back


=head2 TIPS

We'll show you the tips about using C<Cv> that we studied from users.

=over 4

=item *

You can use EncodeImage() and Ptr() when you want to output images in
your CGI without saving to the files.

 use Cv;
 my $img = Cv::Image->new([240, 320], CV_8UC3);
 $img->zero->circle([ 100, 100 ], 100, CV_RGB(255, 100, 100));
 print "Content-type: image/jpg\n\n";
 print $img->encodeImage(".jpg")->ptr;

You can use that to convert for Imager.

 use Imager;
 my $imager = Imager->new(data => $img->encodeImage(".ppm")->ptr);

=item *

We have a configuration to use C<Inline C>.  This makes it easy to
test and extend a variety. How easy is as follows.

 use Cv::Config;
 use Inline C => Config => %Cv::Config::C;

=back

=head1 SAMPLES

We rewrote some OpenCV samples in C<Cv>, and put them in sample/.

=over 4

=item

 bgfg_codebook.pl calibration.pl camshiftdemo.pl capture.pl
 contours.pl convexhull.pl delaunay.pl demhist.pl dft.pl distrans.pl
 drawing.pl edge.pl facedetect.pl fback_c.pl ffilldemo.pl find_obj.pl
 fitellipse.pl houghlines.pl image.pl inpaint.pl kalman.pl kmeans.pl
 laplace.pl lkdemo.pl minarea.pl morphology.pl motempl.pl
 mser_sample.pl polar_transforms.pl pyramid_segmentation.pl squares.pl
 stereo_calib.pl stereo_match.pl tiehash.pl video.pl watershed.pl

=back

=head1 BUGS

=over 4

=item *

Threshold() updates the parameter threshold if threshold-type is
CV_THRESH_OTSU.  It looks like perl magic.  So, you can use
Threshold() is as follows:

 my $bin = $gray->threshold(my $thresh, 255, CV_THRESH_OTSU);

=item *

Constants used in the Perl world is converted into lib/Cv/Constant.pm
from the header file using h2ph.  If it failed, the version of the
installed OpenCV is checked, and copied from the fallback/.

=cut


=item *

In the version 0.07, we decided to remove keyword parameter.  Because
of that has large overhead. In this version, we decided to remove
C<Cv::TieHash> and C<Cv::TieArr>, too.  See C<sample/tiehash.pl>.

=item *

On cygwin, it is necessary to compile OpenCV. 

=item *

The following names that are the kind of alias are obsolete.  Use the
original names C<CV_SOMETHING> because they are shorter.  (Cv-0.13)

 Cv::MAKETYPE, Cv::MAT_DEPTH, Cv::MAT_CN, Cv::MAT_TYPE, Cv::ELEM_SIZE,
 Cv::NODE_TYPE, Cv::IS_SET_ELEM, Cv::SIZEOF

=item *

Usage of the CV_SIZEOF has changed.  Write the name of structure of
OpenCV that you want to know the size as follows. (Cv-0.13)

 CV_SIZEOF('CvContour')

=back

=head1 SEE ALSO

http://github.com/obuk/Cv-Olive


=head1 AUTHOR

MASUDA Yuta E<lt>yuta.cpan@gmail.comE<gt>

=head1 LICENCE

Copyright (c) 2010, 2011, 2012 by Masuda Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
