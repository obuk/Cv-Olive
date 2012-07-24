/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvConnectedComp) for INPUT: */
CvConnectedComp XS_unpack_CvConnectedComp(SV* arg)
{
	const int verbose = 0;
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		CvConnectedComp comp = { 0, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, 0 };
		int n = av_len((AV*)SvRV(arg)) + 1; int i = 0;
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			if (SvTYPE(sv) == SVt_IV || SvTYPE(sv) == SVt_NV ||
				SvTYPE(sv) == SVt_PVNV || SvTYPE(sv) == SVt_PVIV) {
				comp.area = SvNV(sv);
				i++;
			} else {
				fprintf(stderr, "SvTYPE(area) = %d@%d\n", SvTYPE(sv), i);
			}
			if (verbose)
				fprintf(stderr, "comp.area = %g\n", comp.area);
		}
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			comp.value = XS_unpack_CvScalar(sv);
			if (verbose)
				fprintf(stderr, "comp.value = (%g, %g, %g, %g)\n",
						comp.value.val[0], comp.value.val[1],
						comp.value.val[2], comp.value.val[3]);
			i++;
		}
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			comp.rect = XS_unpack_CvRect(sv);
			if (verbose)
				fprintf(stderr, "comp.rect = (%d, %d, %d, %d)\n",
						comp.rect.x, comp.rect.y,
						comp.rect.width, comp.rect.height);
			i++;
		}
		if (i < n) {
			SV* sv = (SV*)(*av_fetch((AV*)SvRV(arg), i, 0));
			if (SvTYPE(sv) == SVt_IV || SvTYPE(sv) == SVt_PVIV) {
				comp.contour = (CvSeq*)SvIV(sv);
				i++;
			} else {
				fprintf(stderr, "type of contour = %d@%d\n", SvTYPE(sv), i);
			}
			if (verbose)
				fprintf(stderr, "comp.contour = %u\n", comp.contour);
		}
		return comp;
	}
	croak("not a CvConnectedComp");
}
