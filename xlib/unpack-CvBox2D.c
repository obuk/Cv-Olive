/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvBox2D) for INPUT: */
CvBox2D XS_unpack_CvBox2D(SV* arg)
{
	const int verbose = 0;
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		CvBox2D box = { { 0, 0 }, { 0, 0 }, 0 };
		int n = av_len((AV*)SvRV(arg)) + 1; int i = 0;
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			box.center = XS_unpack_CvPoint2D32f(sv);
			if (verbose)
				fprintf(stderr, "box.center = (%g, %g)\n",
						box.center.x, box.center.y);
			i++;
		}
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			box.size = XS_unpack_CvSize2D32f(sv);
			if (verbose)
				fprintf(stderr, "box.size = (%g, %g)\n",
						box.size.width, box.size.height);
			i++;
		}
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			if (SvTYPE(sv) == SVt_IV || SvTYPE(sv) == SVt_NV ||
				SvTYPE(sv) == SVt_PVNV || SvTYPE(sv) == SVt_PVIV) {
				box.angle = SvNV(sv);
			} else {
				croak("SvTYPE(box.angle) = %d @ %d\n", SvTYPE(sv), i);
			}
			if (verbose)
				fprintf(stderr, "box.angle = %g\n", (double)box.angle);
			i++;
		}
		return box;
	}
	croak("not a CvBox2D");
}
