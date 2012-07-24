/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvCircle) for INPUT: */
CvCircle XS_unpack_CvCircle(SV* arg)
{
	const int verbose = 0;
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		CvCircle circle = { { 0, 0 }, 0 };
		int n = av_len((AV*)SvRV(arg)) + 1; int i = 0;
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			circle.center = XS_unpack_CvPoint2D32f(sv);
			if (verbose)
				fprintf(stderr, "circle.center = (%g, %g)\n",
						circle.center.x, circle.center.y);
			i++;
		}
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			if (SvTYPE(sv) == SVt_IV || SvTYPE(sv) == SVt_NV ||
				SvTYPE(sv) == SVt_PVNV || SvTYPE(sv) == SVt_PVIV) {
				circle.radius = SvNV(sv);
			} else {
				croak("SvTYPE(circle.radius) = %d @ %d\n", SvTYPE(sv), i);
			}
			if (verbose)
				fprintf(stderr, "circle.radius = %g\n", (double)circle.radius);
			i++;
		}
		return circle;
	}
	croak("not a CvCircle");
}
